class MainController < PageController

  def main
    render html: "<strong>23333</strong>".html_safe

    # render :main
  end
end
