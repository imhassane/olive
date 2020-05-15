# Olive

<strong>Olive</strong> est un langage de programmation très très basique
qui supporte les appels de fonctions et déclarations de variables. <br />
Je le fais pour des fins d'entraînement. J'essaie de comprendre comment les
compilateurs lisent le code, implémentent la logique, les expressions et la
gestion des variables.<br />
Faire ce petit langage m'a permis de me rendre compte combien il était
compliqué de créer un langage notamment le design du langage, le choix du type
du langage (objet, impératif) et aussi d'autres choses comme langage interprété
comme celui-ci ou compilé. <br />

#### Implémentation
J'utilise `elixir` pour le faire vu que c'est un langage fonctionnel qui
facilite tellement la logique par rapport à un autre, j'ai éssayé avec `ocaml`
avant mais la gestion des chaines de caractères y est plus complexe.

#### Lexeur
Mon lexeur sépare le code en caractères puis en tableaux de de tokens. J'ai choisi
cette façon de faire vu que chaque ligne du langage est considérée comme une
nouvelle instruction. Dans d'autres langages ce serait par exemple le `;` mais
le retour à la ligne est plus facile à gérer.

#### Tokenizeur
Le tokenizeur reçoit une liste de tableaux de tokens et se charge de créer un arbre
de token representant chaque instruction. <br />
```
fonction addition(entier a, entier b) faire
  retourne a + b
fin fonction

fonction plus_un(entier a) faire
  retourne a + 1
fin fonction

var a: entier = 15
var b: entier = 12
var r: entier = 0

r = addition(a, b)
r = plus_un(r)
```
Ce code donnera une liste `elixir` qui ressemble à ceci:
```elixir
[
  %{
    name: "addition",
    params: [
      %{name: "a", t: :variable_declaration, type: "entier"},
      %{name: "b", t: :variable_declaration, type: "entier"}
    ],
    t: :function_definition
  },
  %{
    t: :expression,
    value: %{
      left: %{name: :a, t: :variable_call},
      operation: :addition,
      right: %{t: :expression, value: %{name: :b, t: :variable_call}},
      t: :operation
    }
  },
  %{t: :end_function},
  %{
    name: "plus_un",
    params: [%{name: "a", t: :variable_declaration, type: "entier"}],
    t: :function_definition
  },
  %{
    t: :expression,
    value: %{
      left: %{name: :a, t: :variable_call},
      operation: :addition,
      right: %{t: :expression, value: %{t: :value_call, value: 1}},
      t: :operation
    }
  },
  %{t: :end_function},
  %{
    name: :a,
    t: :variable_definition,
    type: :entier,
    value: %{t: :expression, value: %{t: :value_call, value: 15}}
  },
  %{
    name: :b,
    t: :variable_definition,
    type: :entier,
    value: %{t: :expression, value: %{t: :value_call, value: 12}}
  },
  %{
    name: :r,
    t: :variable_definition,
    type: :entier,
    value: %{t: :expression, value: %{t: :value_call, value: 0}}
  },
  %{
    t: :expression,
    value: %{
      left: %{name: :r, t: :variable_call},
      operation: :equal,
      right: %{
        args: [
          %{t: :expression, value: %{name: :a, t: :variable_call}},
          %{t: :expression, value: %{name: :b, t: :variable_call}}
        ],
        name: :addition,
        t: :func_arguments
      },
      t: :operation
    }
  },
  %{
    t: :expression,
    value: %{
      left: %{name: :r, t: :variable_call},
      operation: :equal,
      right: %{
        args: [%{t: :expression, value: %{name: :r, t: :variable_call}}],
        name: :plus_un,
        t: :func_arguments
      },
      t: :operation
    }
  }
]
```

#### Le Parseur
Bon mon parseur est composé des différentes instructions comme les déclarations de variables et fonctions puis un scope
qui va permettre de limiter l'utilisateur des variables que dans les blocs dans lesquels elles sont définies. <br />
```elixir
[
  %Parser.Functions{
    body: [],
    name: :addition,
    return: nil,
    scope: %{functions: %{}, name: :global, variables: %{}},
    variables: %{}
  },
  %Parser.Functions{
    body: [],
    name: :plus_un,
    return: nil,
    scope: %{
      functions: %{
        addition: %Parser.Functions{
          body: [],
          name: :addition,
          return: nil,
          scope: %{functions: %{}, name: :global, variables: %{}},
          variables: %{}
        }
      },
      name: :global,
      variables: %{}
    },
    variables: %{}
  },
  %Parser.Variables{name: :a, type: :entier, value: 15},
  %Parser.Variables{name: :b, type: :entier, value: 12},
  %Parser.Variables{name: :r, type: :entier, value: 0}
]
```
Ici on voit que les fonctions sont rajoutées dans le scope global mais leurs variables n'apparaissent pas ici
parce que ces variables sont enregistrées dans le scope de chaque fonction.
<br />
Ce n'est peut-être pas la manière optimale de faire mais voilà, c'est juste pour créer mon petit langage pour le moment
et c'est beaucoup plus intuitif comme ça.<br />
<strong>Yep, let's do it</strong>