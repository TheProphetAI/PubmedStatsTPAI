#!/bin/bash
psql -h localhost -p 5433 -U postgres -d pubmed -a -f stats.sql