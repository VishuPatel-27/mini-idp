import pytest
import json
from unittest.mock import patch, MagicMock
from app import app, option_a, option_b

# This file has to be changed
@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_homepage_get_sets_cookie(client):
    """GET request should render the voting page and set a voter_id cookie."""
    response = client.get("/")
    assert response.status_code == 200
    assert option_a.encode() in response.data
    assert option_b.encode() in response.data
    assert "voter_id" in response.headers.get("Set-Cookie", "")


@patch("app.get_redis")
def test_vote_post_stores_vote(mock_get_redis, client):
    """POST request should push vote data to Redis and return updated page."""
    # Mock Redis
    mock_redis = MagicMock()
    mock_get_redis.return_value = mock_redis

    response = client.post("/", data={"vote": option_a})

    # Check response
    assert response.status_code == 200
    assert option_a.encode() in response.data

    # Verify Redis push called with expected payload
    args, kwargs = mock_redis.rpush.call_args
    assert args[0] == "votes"
    vote_data = json.loads(args[1])
    assert vote_data["vote"] == option_a
    assert "voter_id" in vote_data


@patch("app.get_redis")
def test_vote_post_preserves_cookie(mock_get_redis, client):
    """Subsequent POST should reuse existing voter_id from cookie."""
    mock_redis = MagicMock()
    mock_get_redis.return_value = mock_redis

    # First GET to get a cookie
    resp_get = client.get("/")
    voter_id = resp_get.headers["Set-Cookie"].split("voter_id=")[1].split(";")[0]

    # Now POST with the cookie
    response = client.post("/", data={"vote": option_b}, headers={"Cookie": f"voter_id={voter_id}"})
    assert response.status_code == 200

    # Verify Redis was called with the same voter_id
    args, kwargs = mock_redis.rpush.call_args
    vote_data = json.loads(args[1])
    assert vote_data["vote"] == option_b
    assert vote_data["voter_id"] == voter_id
