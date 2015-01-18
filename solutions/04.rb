module UI

  def vertical(border: nil, style: nil, &block)
    vertical_instance = Vertical.new(border, style)
    @string = @string + vertical_instance.instance_eval(&block)
  end

  def horizontal(border: nil, style: nil, &block)
    horizontal_instance = Horizontal.new(border, style)
    @string = @string + horizontal_instance.instance_eval(&block)
    @string = add_border(@string, border)
  end

  def apply_style(text_string, style)
    if style == :upcase
      return text_string.upcase
    elsif style == :downcase
      return text_string.downcase
    else text_string
    end
  end

  def add_border(text_string, border)
    text_string = border.to_s + text_string + border.to_s
  end
  class TextScreen
    extend UI

    def self.draw(&block)
      @string = ""
      self.class_eval(&block)
    end

    def self.label(text:, border: nil, style: nil)
      text = apply_style(text, style)
      text = add_border(text, border)
      @string = @string + text
    end
  end

  class Vertical
    include UI
    attr_accessor :border, :style, :longest_text
    def initialize(border, style)
      @border = border
      @style = style
      @string = ""
      @longest_text = 0
    end
    def label(text:, border: self.border, style: self.style)
      if (text.size > @longest_text)
        @longest_text = text.size
      end
      text = apply_style(text, style)
      text = add_border(text, border)
      @string = @string + text + "\n"
    end

    def horizontal(border: nil, style: nil, &block)
      horizon = UI::Horizontal.new(border, style)
      if @string == ""
        then @string = horizon.instance_eval(&block)
      else
        @string = @string + "\n" + horizon.instance_eval(&block)
      end
    end
  end

  class Horizontal
    include UI
    attr_accessor :border, :style
    def initialize(border, style)
      @border = border
      @style = style
      @string = ""
    end

    def horizontal(border: nil, style: nil, &block)
    horizontal_instance = Horizontal.new(border, style)
    @string = @string + horizontal_instance.instance_eval(&block)
    end

    def label(text:, border: self.border, style: self.style)
      text = apply_style(text, style)
      text = add_border(text, border)
      @string = @string + text
    end
  end
end