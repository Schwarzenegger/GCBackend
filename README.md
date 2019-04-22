
# GC Backend

* Ruby 2.5.5
* Rails 5.2.3
* Postgres
* Rspec
* Active Admin
* Fast Json Api
* Grape


## Installation on Mac

### Homebew

First install xcode and its dependencies

After that

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Validate installation with

```
brew doctor
```

### RVM
RVM is my personal preference to manage rubies

To install RVM

```
curl -sSL https://get.rvm.io | bash
```

If you use fish

```
curl -L --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish

echo "rvm default" >> ~/.config/fish/config.fish
```

### Ruby

To install ruby

```
rvm install ruby 2.5.5
```

### Postgres

To install postgres with homebrew just run

```
brew uninstall --force postgresql

rm -rf /usr/local/var/postgres

brew install postgres
```


## Running the project

Last but no least, lets run the project

```
cp config/database.yml.example config/database.yml
```

And edit the files to correspond to your configurations

```
rake db:create
rake db:migrate
```

and finally run the project with

```
rails s
```
## Explaining the app

The app have 5 models

### Admin User
This is the default Active Admin user, I decided to use Active Admin just because it was quickies and easiest way to create a admin interface, I have added a field access_token to this model, this token is used for api endpoints

### Purchase Channel
Created a Purchase Channel model just to keep the models separated, it's just the name field and the relations with other models

### Client

Basically the same thing as PC, but for the client, did this just to organize the app

### Order

Our main model, we have relations with client, pc and batch and we have a simple state machine for managing order status, there 2 enums, one for delivery services and other for status

### Batch

It's here to organize the orders in batches.

## EndPoints

Our main endpoints are

### get /api/purchase_channels
Return all purchase channels

Needs admin authentication

This is paginated

returns:

```json
{
    "data": [
        {
            "id": "1",
            "type": "purchase_channel",
            "attributes": {
                "id": 1,
                "name": "Iguatemi Store",
                "created_at": "2019-04-22 09:40:57 -0300"
            }
        },
        {
            "id": "2",
            "type": "purchase_channel",
            "attributes": {
                "id": 2,
                "name": "Site BR",
                "created_at": "2019-04-22 09:40:57 -0300"
            }
        }
    ]
}
```

### get /api/purchase_channels/:id
Return a specific purchase_channel

Needs admin authentication

This is paginated

returns:

```json
    {
    "data": {
        "id": "1",
        "type": "purchase_channel",
        "attributes": {
            "id": 1,
            "name": "Iguatemi Store",
            "created_at": "2019-04-22 09:40:57 -0300"
        }
    }
}
```

OBS: Those 2 endpoints were not necessary for the app, bur as PC was the first model I created, I decided to build those endpoints so I can create the Api Base

### get /api/orders

Return all orders or search by purchase_channel, status and/or client name

Needs admin authentication, can be paginated

returns

```json
{
    "data": [
        {
            "id": "2",
            "type": "order",
            "attributes": {
                "id": 2,
                "reference": "1/IS-1555678002",
                "delivery_address": "28950 Rodovia Leonardo",
                "delivery_service": "sedex",
                "total_value": 22.01,
                "line_items": [
                    "Magmar",
                    "Snorlax"
                ],
                "status": "ready",
                "when_entered_production": null,
                "finished_production": null,
                "send_date": null,
                "created_at": "2019-04-19 09:46:42 -0300",
                "updated_at": "2019-04-19 09:46:42 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "12",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": null
                }
            }
        },
        {
            "id": "3",
            "type": "order",
            "attributes": {
                "id": 3,
                "reference": "1/IS-1555678004",
                "delivery_address": "22339 Marginal Carlos Eduardo",
                "delivery_service": "pac",
                "total_value": 37.01,
                "line_items": [
                    "Weedle",
                    "Lapras"
                ],
                "status": "ready",
                "when_entered_production": null,
                "finished_production": null,
                "send_date": null,
                "created_at": "2019-04-19 09:46:44 -0300",
                "updated_at": "2019-04-19 09:46:44 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "13",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": null
                }
            }
        }
    ]
}
```

### get /api/orders/:id

Return a specific order

Needs admin authentication

returns

```json
{
    "data": [
        {
            "id": "2",
            "type": "order",
            "attributes": {
                "id": 2,
                "reference": "1/IS-1555678002",
                "delivery_address": "28950 Rodovia Leonardo",
                "delivery_service": "sedex",
                "total_value": 22.01,
                "line_items": [
                    "Magmar",
                    "Snorlax"
                ],
                "status": "ready",
                "when_entered_production": null,
                "finished_production": null,
                "send_date": null,
                "created_at": "2019-04-19 09:46:42 -0300",
                "updated_at": "2019-04-19 09:46:42 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "12",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": null
                }
            }
        }
     ]
}
```

### post /api/orders/

Create a new order

Needs admin authentication

```json
{
    "data": [
        {
            "id": "2",
            "type": "order",
            "attributes": {
                "id": 2,
                "reference": "1/IS-1555678002",
                "delivery_address": "28950 Rodovia Leonardo",
                "delivery_service": "sedex",
                "total_value": 22.01,
                "line_items": [
                    "Magmar",
                    "Snorlax"
                ],
                "status": "ready",
                "when_entered_production": null,
                "finished_production": null,
                "send_date": null,
                "created_at": "2019-04-19 09:46:42 -0300",
                "updated_at": "2019-04-19 09:46:42 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "12",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": null
                }
            }
        }
     ]
}
```

### put /api/bathces/:id

Edit a order

Needs admin authentication

returns :

```json
{
    "data": [
        {
            "id": "2",
            "type": "order",
            "attributes": {
                "id": 2,
                "reference": "1/IS-1555678002",
                "delivery_address": "28950 Rodovia Leonardo",
                "delivery_service": "sedex",
                "total_value": 22.01,
                "line_items": [
                    "Magmar",
                    "Snorlax"
                ],
                "status": "ready",
                "when_entered_production": null,
                "finished_production": null,
                "send_date": null,
                "created_at": "2019-04-19 09:46:42 -0300",
                "updated_at": "2019-04-19 09:46:42 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "12",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": null
                }
            }
        }
     ]
}
```

### post /api/bathces/

Create a batch

Needs admin authentication

returns :

```json
{
    "data": {
        "id": "2",
        "type": "batch",
        "attributes": {
            "id": 2,
            "reference": "20190422-1555940036"
        },
        "relationships": {
            "orders": {
                "data": [
                    {
                        "id": "2",
                        "type": "order"
                    },
                    {
                        "id": "3",
                        "type": "order"
                    },
                    {
                        "id": "4",
                        "type": "order"
                    },
                    {
                        "id": "5",
                        "type": "order"
                    },
                    {
                        "id": "6",
                        "type": "order"
                    },
                    {
                        "id": "7",
                        "type": "order"
                    }
                ]
            }
        }
    }
}
```

### put /api/bathces/:id/close

Close orders of a batch

return

```json
{
    "data": [
        {
            "id": "2",
            "type": "order",
            "attributes": {
                "id": 2,
                "reference": "1/IS-1555678002",
                "delivery_address": "28950 Rodovia Leonardo",
                "delivery_service": "sedex",
                "total_value": 22.01,
                "line_items": [
                    "Magmar",
                    "Snorlax"
                ],
                "status": "closing",
                "when_entered_production": "2019-04-22 10:33:56 -0300",
                "finished_production": "2019-04-22 10:35:18 -0300",
                "send_date": null,
                "created_at": "2019-04-19 09:46:42 -0300",
                "updated_at": "2019-04-22 10:35:18 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "12",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": {
                        "id": "2",
                        "type": "batch"
                    }
                }
            }
        },
        {
            "id": "3",
            "type": "order",
            "attributes": {
                "id": 3,
                "reference": "1/IS-1555678004",
                "delivery_address": "22339 Marginal Carlos Eduardo",
                "delivery_service": "pac",
                "total_value": 37.01,
                "line_items": [
                    "Weedle",
                    "Lapras"
                ],
                "status": "closing",
                "when_entered_production": "2019-04-22 10:33:56 -0300",
                "finished_production": "2019-04-22 10:35:18 -0300",
                "send_date": null,
                "created_at": "2019-04-19 09:46:44 -0300",
                "updated_at": "2019-04-22 10:35:18 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "13",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": {
                        "id": "2",
                        "type": "batch"
                    }
                }
            }
        }

```

### put /api/bathces/:id/sent

sent orders of a batch, need delivery service enum this range from 1-3

return

```json
{
    "data": [
        {
            "id": "2",
            "type": "order",
            "attributes": {
                "id": 2,
                "reference": "1/IS-1555678002",
                "delivery_address": "28950 Rodovia Leonardo",
                "delivery_service": "sedex",
                "total_value": 22.01,
                "line_items": [
                    "Magmar",
                    "Snorlax"
                ],
                "status": "closing",
                "when_entered_production": "2019-04-22 10:33:56 -0300",
                "finished_production": "2019-04-22 10:35:18 -0300",
                "send_date": null,
                "created_at": "2019-04-19 09:46:42 -0300",
                "updated_at": "2019-04-22 10:35:18 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "12",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": {
                        "id": "2",
                        "type": "batch"
                    }
                }
            }
        },
        {
            "id": "3",
            "type": "order",
            "attributes": {
                "id": 3,
                "reference": "1/IS-1555678004",
                "delivery_address": "22339 Marginal Carlos Eduardo",
                "delivery_service": "pac",
                "total_value": 37.01,
                "line_items": [
                    "Weedle",
                    "Lapras"
                ],
                "status": "closing",
                "when_entered_production": "2019-04-22 10:33:56 -0300",
                "finished_production": "2019-04-22 10:35:18 -0300",
                "send_date": null,
                "created_at": "2019-04-19 09:46:44 -0300",
                "updated_at": "2019-04-22 10:35:18 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "13",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": {
                        "id": "2",
                        "type": "batch"
                    }
                }
            }
        },
        {
            "id": "4",
            "type": "order",
            "attributes": {
                "id": 4,
                "reference": "1/IS-1555678005",
                "delivery_address": "3555 Avenida Júlio Ambrósio",
                "delivery_service": "sedex",
                "total_value": 55.03,
                "line_items": [
                    "Exeggutor",
                    "Mew"
                ],
                "status": "closing",
                "when_entered_production": "2019-04-22 10:33:56 -0300",
                "finished_production": "2019-04-22 10:35:18 -0300",
                "send_date": null,
                "created_at": "2019-04-19 09:46:45 -0300",
                "updated_at": "2019-04-22 10:35:18 -0300"
            },
            "relationships": {
                "client": {
                    "data": {
                        "id": "14",
                        "type": "client"
                    }
                },
                "purchase_channel": {
                    "data": {
                        "id": "1",
                        "type": "purchase_channel"
                    }
                },
                "batch": {
                    "data": {
                        "id": "2",
                        "type": "batch"
                    }
                }
            }
        }

```

### get /api/reports/simple_financial

Simple Finacial Report, show all PC and sum of all orders

returns
```json

[
    {
        "name": "Iguatemi Store",
        "value": 326.19
    },
    {
        "name": "Site BR",
        "value": 0
    },
    {
        "name": "Site USA",
        "value": 0
    },
    {
        "name": "Brites-Aroeira",
        "value": 0
    },
    {
        "name": "da Rocha Comércio",
        "value": 0
    },
    {
        "name": "Videira LTDA",
        "value": 0
    },
    {
        "name": "dos Reis-Brum",
        "value": 0
    },
    {
        "name": "Roriz, Vimaranes e Custódio",
        "value": 0
    },
    {
        "name": "Monteiro LTDA",
        "value": 0
    },
    {
        "name": "Solimões-Jaques",
        "value": 138.09
    }
]
```

OBS: Usually  I would document this using Grape Swagger

## Heroku

There is a Heroku Staging url

https://gc-backend-test.herokuapp.com/

admin@example.com
password

access_token PIuRSHQ4v6cAMtWRzRgDBwtt
