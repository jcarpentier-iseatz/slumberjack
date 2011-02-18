require 'lib/xmlformat'

#Global Vars for xml formatter
@@text_se = "[^<]+"
@@until_hyphen = "[^-]*-"
@@until_2_hyphens = "#{@@until_hyphen}(?:[^-]#{@@until_hyphen})*-"
@@comment_ce = "#{@@until_2_hyphens}>?"
@@until_rsbs = "[^\\]]*\\](?:[^\\]]+\\])*\\]+"
@@cdata_ce = "#{@@until_rsbs}(?:[^\\]>]#{@@until_rsbs})*>"
@@s = "[ \\n\\t\\r]+"
@@name_strt = "[A-Za-z_:]|[^\\x00-\\x7F]"
@@name_char = "[A-Za-z0-9_:.-]|[^\\x00-\\x7F]"
@@name = "(?:#{@@name_strt})(?:#{@@name_char})*"
@@quote_se = "\"[^\"]*\"|'[^']*'"
@@dt_ident_se = "#{@@s}#{@@name}(?:#{@@s}(?:#{@@name}|#{@@quote_se}))*"
@@markup_decl_ce = "(?:[^\\]\"'><]+|#{@@quote_se})*>"
@@s1 = "[\\n\\r\\t ]"
@@until_qms = "[^?]*\\?+"
@@pi_tail = "\\?>|#{@@s1}#{@@until_qms}(?:[^>?]#{@@until_qms})*>"
@@dt_item_se =
"<(?:!(?:--#{@@until_2_hyphens}>|[^-]#{@@markup_decl_ce})|\\?#{@@name}(?:#{@@pi_tail}))|%#{@@name};|#{@@s}"
@@doctype_ce =
"#{@@dt_ident_se}(?:#{@@s})?(?:\\[(?:#{@@dt_item_se})*\\](?:#{@@s})?)?>?"
@@decl_ce =
"--(?:#{@@comment_ce})?|\\[CDATA\\[(?:#{@@cdata_ce})?|DOCTYPE(?:#{@@doctype_ce})?"
@@pi_ce = "#{@@name}(?:#{@@pi_tail})?"
@@end_tag_ce = "#{@@name}(?:#{@@s})?>?"
@@att_val_se = "\"[^<\"]*\"|'[^<']*'"
@@elem_tag_se =
"#{@@name}(?:#{@@s}#{@@name}(?:#{@@s})?=(?:#{@@s})?(?:#{@@att_val_se}))*(?:#{@@s})?/?>?"
@@markup_spe =
"<(?:!(?:#{@@decl_ce})?|\\?(?:#{@@pi_ce})?|/(?:#{@@end_tag_ce})?|(?:#{@@elem_tag_se})?)"
@@xml_spe = Regexp.new("#{@@text_se}|#{@@markup_spe}")

@@opt_list = {
  "format"        => [ "block", "inline", "verbatim" ],
  "normalize"     => [ "yes", "no" ],
  "subindent"     => nil,
  "wrap-length"   => nil,
  "entry-break"   => nil,
  "exit-break"    => nil,
  "element-break" => nil
}

module Saxe
  SLOG_PATH = '/'
  SUPPLIER_SLOG_PATH = '/supplier'
  
  TIMEFORMAT = "%m/%d/%Y %H:%M:%S"
  
  module ViewHelpers
    
    def table_row(th, td)
      "<tr><th>#{th}</th><td>#{td}</td></tr>\n"
    end
  
    def data_table(record, keys, table_class="")
      buff = "<table class='#{table_class}'>\n"
      keys.each do |key|
        buff += "<tr>\n<th>#{key}</th>\n"
        buff += "<td>#{record.attributes[key]}</td>\n</tr>"
      end
      buff += "</table>"
    end
  
    def x(text)
      unless text.nil? || text.blank?
        xf = XMLFormat::XMLFormatter.new
        escape_html(xf.process_doc(text, false, false, false, false))
      end
    end
   
    def slog_link(id)
      "<a href='/?id=#{id}'>#{id}</a>"
    end
    
    def supplier_slog_link(id, params = {})
      "<a href='/supplier#{hash_to_params(params.merge(:id => id))}'>#{id}</a>"
    end
   
    def offset_bar(url, params)
      buff = "<span id='offset'>Offset: "
        (0..10).each do |x|
          if x == params[:o].to_i
            buff += "<b>#{x}</b> "
          else
            buff += "<a href='#{link(url, params.merge({'o' => x}))}'>#{x}</a> "
          end
        end
      buff += "</span>"
    end
    
    def include_js(scripts)
      buff = ""
      if scripts.kind_of?(Array)
        scripts.each do |script|
          buff += "<script type='text/javascript' src=#{script}></script>\n"
        end
      else
        buff += "<script type='text/javascript' src=#{scripts}></script>\n"
      end
      buff
    end
    
    def include_css(sheets)
      buff = ""
      if sheets.kind_of?(Array)
        sheets.each do |sheet|
          buff += "<link type='text/css' rel='Stylesheet' href='#{sheet}'/>\n"
        end
      else
        buff += "<link type='text/css' rel='Stylesheet' href='#{sheets}'/>\n"
      end
      buff
    end
    
    def tag_line
      lines = ["Quality slogs since 1943."]
      lines << "The champagne of beers"
      lines << "If a slog falls in the forrest..."
      lines[rand(lines.count)]
    end
    
    def link(url, opts)
      buff = "#{url}?"
      opts.each_pair do |key, data|
        buff += "#{key}=#{data}&" unless data.blank?
      end
      buff
    end
    
    def hash_to_params(opts)
      return nil unless opts.length > 0
      buff = []
      opts.each_pair do |key, data|
        buff << "#{key}=#{data}" unless data.blank?
      end
      return nil unless buff.length > 0
      "?#{buff.join("&")}"
    end
  end
end