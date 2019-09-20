# frozen_string_literal: true

module ThemePark
  class CLI
    module Components
      class Component
        attr_reader :props
        def initialize(**props)
          @props = props
        end
      end

      class ThemeParkLogo < Component
        def render
          %q{
          ______                _           _
          | ___ \              | |         ( )
          | |_/ / ___ _ __   __| | ___ _ __|/ ___
          | ___ \/ _ \ '_ \ / _` |/ _ \ '__| / __|
          | |_/ /  __/ | | | (_| |  __/ |    \__ \
          \____/ \___|_| |_|\__,_|\___|_|    |___/


           _   _                                            _
          | | | |                                          | |
          | |_| |__   ___ _ __ ___   ___   _ __   __ _ _ __| | __
          | __| '_ \ / _ \ '_ ` _ \ / _ \ | '_ \ / _` | '__| |/ /
          | |_| | | |  __/ | | | | |  __/ | |_) | (_| | |  |   <
           \__|_| |_|\___|_| |_| |_|\___| | .__/ \__,_|_|  |_|\_\
                                          | |
                                          |_|
          }
        end
      end

      class CurseGoodbye < Component
        def render
          %q{
                   o
                   |
                 ,'~'.
                /     \
               |   ____|_
               |  '___,,_'         .--------------------.
               |  ||(o |o)|       ( Stop wasting my time )
               |   -------         ,--------------------'
               |  _____|         -'
               \  '####,
                -------
              /________\
            (  )        |)
            '_ ' ,------|\         _
           /_ /  |      |_\        ||
          /_ /|  |     o| _\      _||
         /_ / |  |      |\ _\____//' |
        (  (  |  |      | (_,_,_,____/
         \ _\ |   ------|
          \ _\|_________|
           \ _\ \__\\__\
           |__| |__||__|
        ||/__/  |__||__|
                |__||__|
                |__||__|
                /__)/__)
               /__//__/
              /__//__/
             /__//__/.
           .'    '.   '.
          (_kOs____)____)
          }
        end
      end

      class Ciao < Component
        def render
          %q{
           .-------------.
          ( Ciao, losers! )
           '-------------,
                           `.
                             `.
                               `. ___
                              __,' __`.                _..----....____
                  __...--.'``;.   ,.   ;``--..__     .'    ,-._    _.-'
            _..-''-------'   `'   `'   `'     O ``-''._   (,;') _,'
          ,'________________                          \`-._`-','
           `._              ```````````------...___   '-.._'-:
              ```--.._      ,.                     ````--...__\-.
                      `.--. `-`                       ____    |  |`
                        `. `.                       ,'`````.  ;  ;`
                          `._`.        __________   `.      \'__/`
                             `-:._____/______/___/____`.     \  `
                                         |       `._    `.    \
                                         `._________`-.   `.   `.___
                                                       SSt  `------'`
          }
        end
      end

      class BenderSay < Component
        def render
          %q{

                  _
                 ( )
                  H
                  H
                 _H_              ___%s__
              .-'-.-'-.          |   %s  |
             /         \         |   %s  |
            |           |        |   %s  |
            |   .-------'._      |   %s  |
            |  / /  '.' '. \     |___%s__|
            |  \ \ @   @ / /       /
            |   '---------'       /
            |    _______|        /
            |  .'-+-+-+|        /
            |  '.-+-+-+|
            |    """""" |
            '-.__   __.-'
                 """
          } % prepare_lines
        end

        private

        def prepare_lines
          max_size = props[:lines].map(&:size).max

          borders = '_' * max_size
          blank_lines = ' ' * max_size

          adjusted_lines = props[:lines].map { |line| line.ljust(max_size) }

          [
            borders,
            blank_lines,
            *adjusted_lines,
            borders
          ]
        end
      end
    end
  end
end
