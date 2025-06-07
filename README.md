
# ✨ Bible IA — Intentions & Réponses inspirées

Bible IA est une application Ruby on Rails simple, douce et spirituelle ✝️, qui permet d’écrire une intention ou une prière, et de recevoir en retour un verset de l'Évangile selon Matthieu (traduction Osty & Trinquet) accompagné d’une citation d’Emmet Fox ✨.

---

## 🧠 Fonctionnement

1. **L’utilisateur écrit son intention** depuis l’interface.
2. **Une extraction de mots-clés** est effectuée localement à partir du contenu du message.
3. L’**API OpenAI** (optionnelle, si disponible) peut être appelée pour faire une analyse sémantique plus fine.
4. Un verset pertinent de l’Évangile selon Matthieu est sélectionné :
   - soit par correspondance avec les mots-clés,
   - soit aléatoirement s’il n’y a pas de correspondance.
5. Une **citation inspirante d’Emmet Fox** est ajoutée à la réponse.
6. Le tout est affiché clairement et lisiblement dans l'interface.

---

## 📦 Technologies utilisées

- Ruby on Rails 8
- SQLite3
- Tailwind CSS
- YAML (stockage local des versets et citations)
- OpenAI API (si disponible)

---

## 🛠 Installation

```bash
git clone https://github.com/toncompte/bible_ia.git
cd bible_ia
bundle install
rails db:migrate
```

### Configuration Tailwind (si besoin) :

```bash
./bin/rails tailwindcss:build
```

---

## 🔐 Configuration OpenAI (facultatif)

Si tu souhaites utiliser l’analyse par l’IA OpenAI :

1. Obtiens une clé API depuis [https://platform.openai.com/](https://platform.openai.com/)
2. Crée un fichier `.env` :

```bash
OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxx
```

3. Installe la gem `dotenv-rails` si ce n’est pas encore fait.

---

## 📁 Fichiers YAML utilisés

* `config/matthieu.yaml` : versets extraits de l’Évangile selon Matthieu
* `config/emmet_fox.yaml` : citations inspirantes d’Emmet Fox

Ces fichiers permettent à l’application de fonctionner **même sans connexion Internet**.

---

## 🖼 Capture d’écran

> ![Capture interface](doc/screenshot.png)

---

## 📌 TODO

* [ ] Ajouter une interface mobile responsive
* [ ] Intégrer d’autres livres bibliques
* [ ] Envoyer les intentions à une communauté de prière
* [ ] Exporter les réponses sous forme de carte PDF imprimable

---

## 📜 Licence

Projet personnel non commercial. Basé sur des textes libres de droits.

---

## 🙏 Remerciements

* Traduction de la Bible : Osty & Trinquet (1973)
* Emmet Fox, pour ses paroles de sagesse
* OpenAI pour la magie ✨

---


