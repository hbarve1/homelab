# PostgreSQL

## Port Forwarding

microk8s kubectl port-forward -n databases svc/postgres-16-postgresql 5432:5432

## Connecting to the database

```
psql -h localhost -p 5432 -U postgres -d postgres
```
