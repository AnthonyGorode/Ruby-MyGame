class Personne
  attr_accessor :nom, :points_de_vie, :en_vie, :force

  def initialize(nom,force)
    @nom = nom
    @points_de_vie = 100
    @force = force
    @en_vie = true
  end

  def info
    # A faire:
    # - Renvoie le nom et les points de vie si la personne est en vie
    # - Renvoie le nom et "vaincu" si la personne a été vaincue
    if @en_vie
      puts "#{@nom} : #{@points_de_vie}/100"
    else
      puts "#{@nom} a été vaincu"
    end
  end

  def attaque(personne)
    # A faire:
    # - Fait subir des dégats à la personne passée en paramètre
    # - Affiche ce qu'il s'est passé
      puts "#{@nom} a attaqué #{personne.nom}"
      self.subit_attaque(@force,personne)
  end

  def subit_attaque(degats_recus,personne)
    # A faire:
    # - Réduit les points de vie en fonction des dégats reçus
    # - Affiche ce qu'il s'est passé
    # - Détermine si la personne est toujours en_vie ou non

    personne.points_de_vie -= @force
    puts "#{personne.nom} reçoit #{@force} de dégats" 

    personne.en_vie = false if personne.points_de_vie <= 0
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus, :potion_soin, :potion_force

  def initialize(nom,force)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0
    # J'ai rajouté une limite pour les soins et les dégâts
    @potion_soin = 3
    @potion_force = 3

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom,force)
  end

  def degats
    # A faire:
    # - Calculer les dégats
    # - Affiche ce qu'il s'est passé
  end

  def soin
    # A faire:
    # - Gagner de la vie
    # - Affiche ce qu'il s'est passé
    if @potion_soin > 0
      @potion_soin -= 1 
      @points_de_vie += 20

      puts "Potion utilisé : #{@potion_soin}/3 restants"
    else
      puts "désolé vous n'avez plus de potions de soins"
    end
  end

  def ameliorer_degats
    # A faire:
    # - Augmenter les dégats bonus
    # - Affiche ce qu'il s'est passé
    if @potion_force > 0
      @potion_force -= 1

      @degats_bonus += 20
      puts "#{@nom} profite de #{@degats_bonus} dégâts de bonus"
      
    # ici j'ai galéré car il n'accepte pas des "valeurs nil"
    # pour préciser que "force" est un attribut, j'ai rajouté "self"
    self.force = force + @degats_bonus
    else
      puts "désolé vous n'avez plus de potions de force"
    end
  end
end

class Ennemi < Personne
  def degats
    # A faire:
    # - Calculer les dégats
  end
end

class Jeu
  attr_accessor :choix

  def choix_user(choix)
    @choix = choix
  end

  def self.actions_possibles(monde,joueur)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner : #{joueur.potion_soin}/3 potions"
    puts "1 - Améliorer son attaque : #{joueur.potion_force}/3 potions"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer " 
      puts "#{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur,monde)
    # A faire:
    # - Déterminer la condition de fin du jeu

    # à chaque ennemi vivant "is_alive" sera incrémenté de 1
    is_alive = 0
    monde.ennemis.each do |ennemi|
      is_alive += 1 if ennemi.points_de_vie > 0
    end

    if (joueur.points_de_vie <= 0 or is_alive == 0)
      return true
    else
      return false
    end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    # A faire:
    # - Ne retourner que les ennemis en vie
    ennemis_alive = []
    @ennemis.each do |ennemi|
     ennemis_alive.push(ennemi) if ennemi.points_de_vie > 0
    end

    return ennemis_alive
  end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog",8),
  Ennemi.new("Goblin",5),
  Ennemi.new("Squelette",3)
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin",40)

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Je déclare avant d'entrer dans la boucle pour récupérer le choix
jeu = Jeu.new

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde,joueur)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"

    # Ici je récupére le choix dans l'instance de Jeu
    jeu.choix_user(choix)
    break
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    if monde.ennemis[choix - 2]
      ennemi_a_attaquer = monde.ennemis[choix - 2]
      joueur.attaque(ennemi_a_attaquer)
    else
      puts "\nOups! désolé cette commande n'existe pas, veuillez réessayer\n"
    end
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héro :" 
  puts "#{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

# A faire:
# - Afficher le résultat de la partie
if jeu.choix != 99
  if joueur.en_vie
    puts "Vous avez gagné !"
  else
    puts "Vous avez perdu !"
  end
end