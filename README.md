# Replay Client

This program allows you to read a stream of requests from site A and replay them on site B. 
This is useful for real world load testing.

## Setup

You need a Redis server and two instances of an application (we'll call them Live and Test)
When your application receives an incoming request, publish the request info to Redis for consumption by the replay client.

    Live ==(request data)==> Redis ====> Replay ====> Test

## To Run

    REPLAY_ENV="development" coffee replay.coffee

## Configuration

Modify config.coffee to suit your needs. 
