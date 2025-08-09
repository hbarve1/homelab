# Load .env variables automatically for terraform commands
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi