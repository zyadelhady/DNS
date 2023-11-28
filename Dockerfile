FROM elixir:1.15.7-alpine

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix deps.get

COPY . ./ 

CMD [ "iex","-S","mix" ]


