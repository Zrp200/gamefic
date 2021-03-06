﻿require 'rexml/document'

module Gamefic

  module Html
    def self.fix_ampersands(text)
      codes = []
      ENTITIES.keys.each { |e|
        codes.push e[1..-1]
      }
      piped = codes.join('|')
      re = Regexp.new("&(?!(#{piped}))")
      text.gsub(re, '&amp;\1')
    end
    def self.encode(text)
      Gamefic::Html::ENTITIES.each { |k, v|
        while text.include?(k)
          text[v] = k
        end
      }
      text
    end
    def self.decode(text)
      Gamefic::Html::ENTITIES.each { |k, v|
        while text.include?(k)
          text[k] = v
        end
      }
      text
    end
    def self.parse(code)
      code = fix_ampersands(code).strip
      last = nil
      begin
        doc = REXML::Document.new code
      rescue REXML::ParseException => e
        if e.source.buffer != last
          if e.source.buffer[0,1] == '<'
            code = code[0,(code.length - e.source.buffer.length)] + '&lt;' + e.source.buffer[1..-1]
            last = e.source.buffer
            retry
          end
        end
        raise e
      end
    end
  end

  module Html
    ENTITIES = { "&quot;" => "\"", "&amp;" => "&", "&lt;" => "<", "&gt;" => ">", "&nbsp;" => " ", "&iexcl;" => "¡", "&cent;" => "¢", "&pound;" => "£", "&curren;" => "¤", "&yen;" => "¥", "&brvbar;" => "¦", "&sect;" => "§", "&uml;" => "¨", "&copy;" => "©", "&ordf;" => "ª", "&laquo;" => "«", "&not;" => "¬", "&shy;" => "­", "&reg;" => "®", "&macr;" => "¯", "&deg;" => "°", "&plusmn;" => "±", "&sup2;" => "²", "&sup3;" => "³", "&acute;" => "´", "&micro;" => "µ", "&para;" => "¶", "&middot;" => "·", "&cedil;" => "¸", "&sup1;" => "¹", "&ordm;" => "º", "&raquo;" => "»", "&frac14;" => "¼", "&frac12;" => "½", "&frac34;" => "¾", "&iquest;" => "¿", "&Agrave;" => "À", "&Aacute;" => "Á", "&Acirc;" => "Â", "&Atilde;" => "Ã", "&Auml;" => "Ä", "&Aring;" => "Å", "&AElig;" => "Æ", "&Ccedil;" => "Ç", "&Egrave;" => "È", "&Eacute;" => "É", "&Ecirc;" => "Ê", "&Euml;" => "Ë", "&Igrave;" => "Ì", "&Iacute;" => "Í", "&Icirc;" => "Î", "&Iuml;" => "Ï", "&ETH;" => "Ð", "&Ntilde;" => "Ñ", "&Ograve;" => "Ò", "&Oacute;" => "Ó", "&Ocirc;" => "Ô", "&Otilde;" => "Õ", "&Ouml;" => "Ö", "&times;" => "×", "&Oslash;" => "Ø", "&Ugrave;" => "Ù", "&Uacute;" => "Ú", "&Ucirc;" => "Û", "&Uuml;" => "Ü", "&Yacute;" => "Ý", "&THORN;" => "Þ", "&szlig;" => "ß", "&agrave;" => "à", "&aacute;" => "á", "&acirc;" => "â", "&atilde;" => "ã", "&auml;" => "ä", "&aring;" => "å", "&aelig;" => "æ", "&ccedil;" => "ç", "&egrave;" => "è", "&eacute;" => "é", "&ecirc;" => "ê", "&euml;" => "ë", "&igrave;" => "ì", "&iacute;" => "í", "&icirc;" => "î", "&iuml;" => "ï", "&eth;" => "ð", "&ntilde;" => "ñ", "&ograve;" => "ò", "&oacute;" => "ó", "&ocirc;" => "ô", "&otilde;" => "õ", "&ouml;" => "ö", "&divide;" => "÷", "&oslash;" => "ø", "&ugrave;" => "ù", "&uacute;" => "ú", "&ucirc;" => "û", "&uuml;" => "ü", "&yacute;" => "ý", "&thorn;" => "þ", "&yuml;" => "ÿ", "&OElig;" => "Œ", "&oelig;" => "œ", "&Scaron;" => "Š", "&scaron;" => "š", "&Yuml;" => "Ÿ", "&fnof;" => "ƒ", "&circ;" => "ˆ", "&tilde;" => "˜", "&Alpha;" => "Α", "&Beta;" => "Β", "&Gamma;" => "Γ", "&Delta;" => "Δ", "&Epsilon;" => "Ε", "&Zeta;" => "Ζ", "&Eta;" => "Η", "&Theta;" => "Θ", "&Iota;" => "Ι", "&Kappa;" => "Κ", "&Lambda;" => "Λ", "&Mu;" => "Μ", "&Nu;" => "Ν", "&Xi;" => "Ξ", "&Omicron;" => "Ο", "&Pi;" => "Π", "&Rho;" => "Ρ", "&Sigma;" => "Σ", "&Tau;" => "Τ", "&Upsilon;" => "Υ", "&Phi;" => "Φ", "&Chi;" => "Χ", "&Psi;" => "Ψ", "&Omega;" => "Ω", "&alpha;" => "α", "&beta;" => "β", "&gamma;" => "γ", "&delta;" => "δ", "&epsilon;" => "ε", "&zeta;" => "ζ", "&eta;" => "η", "&theta;" => "θ", "&iota;" => "ι", "&kappa;" => "κ", "&lambda;" => "λ", "&mu;" => "μ", "&nu;" => "ν", "&xi;" => "ξ", "&omicron;" => "ο", "&pi;" => "π", "&rho;" => "ρ", "&sigmaf;" => "ς", "&sigma;" => "σ", "&tau;" => "τ", "&upsilon;" => "υ", "&phi;" => "φ", "&chi;" => "χ", "&psi;" => "ψ", "&omega;" => "ω", "&thetasym;" => "ϑ", "&upsih;" => "ϒ", "&piv;" => "ϖ", "&ensp;" => " ", "&emsp;" => " ", "&thinsp;" => " ", "&zwnj;" => "‌", "&zwj;" => "‍", "&lrm;" => "‎", "&rlm;" => "‏", "&ndash;" => "–", "&mdash;" => "—", "&lsquo;" => "‘", "&rsquo;" => "’", "&sbquo;" => "‚", "&ldquo;" => "“", "&rdquo;" => "”", "&bdquo;" => "„", "&dagger;" => "†", "&Dagger;" => "‡", "&bull;" => "•", "&hellip;" => "…", "&permil;" => "‰", "&prime;" => "′", "&Prime;" => "″", "&lsaquo;" => "‹", "&rsaquo;" => "›", "&oline;" => "‾", "&frasl;" => "⁄", "&euro;" => "€", "&image;" => "ℑ", "&weierp;" => "℘", "&real;" => "ℜ", "&trade;" => "™", "&alefsym;" => "ℵ", "&larr;" => "←", "&uarr;" => "↑", "&rarr;" => "→", "&darr;" => "↓", "&harr;" => "↔", "&crarr;" => "↵", "&lArr;" => "⇐", "&uArr;" => "⇑", "&rArr;" => "⇒", "&dArr;" => "⇓", "&hArr;" => "⇔", "&forall;" => "∀", "&part;" => "∂", "&exist;" => "∃", "&empty;" => "∅", "&nabla;" => "∇", "&isin;" => "∈", "&notin;" => "∉", "&ni;" => "∋", "&prod;" => "∏", "&sum;" => "∑", "&minus;" => "−", "&lowast;" => "∗", "&radic;" => "√", "&prop;" => "∝", "&infin;" => "∞", "&ang;" => "∠", "&and;" => "∧", "&or;" => "∨", "&cap;" => "∩", "&cup;" => "∪", "&int;" => "∫", "&there4;" => "∴", "&sim;" => "∼", "&cong;" => "≅", "&asymp;" => "≈", "&ne;" => "≠", "&equiv;" => "≡", "&le;" => "≤", "&ge;" => "≥", "&sub;" => "⊂", "&sup;" => "⊃", "&nsub;" => "⊄", "&sube;" => "⊆", "&supe;" => "⊇", "&oplus;" => "⊕", "&otimes;" => "⊗", "&perp;" => "⊥", "&sdot;" => "⋅", "&lceil;" => "⌈", "&rceil;" => "⌉", "&lfloor;" => "⌊", "&rfloor;" => "⌋", "&lang;" => "〈", "&rang;" => "〉", "&loz;" => "◊", "&spades;" => "♠", "&clubs;" => "♣", "&hearts;" => "♥", "&diams;" => "♦" }
  end

end
