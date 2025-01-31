require 'open-uri'

Jekyll::Hooks.register :site, :after_init do |site|
  navigations_map = {
    "aspnet-ajax" => "asp-net-ajax", 
    "aspnet-core" => "asp-net-core",
    "aspnet-mvc" => "asp-net-mvc", 
    "dpl" => "document-processing", 
    "fiddler" => "fiddler-classic", 
    "fiddler-core" => "fiddler-core",
    "fiddler-everywhere" => "fiddler-everywhere",
    "fiddler-jam" => "fiddler-jam",
    "justdecompile" => "just-decompile", 
    "justmock" => "just-mock", 
    "kendo-ui" => "kendo-ui-jquery", 
    "reporting" => "reporting", 
    "report-server" => "report-server", 
    "silverlight" => "silverlight", 
    "teststudio" => "test-studio", 
    "teststudio-apis" => "api-testing", 
    "teststudiodev" => "test-studio-dev-edition", 
    "uwp" => "uwp", 
    "winforms" => "winforms", 
    "wpf" => "wpf", 
    "xamarin" => "xamarin",
    "maui" => "maui-ui", 
    "php-ui" => "php",
    "jsp-ui" => "jsp",
    "blazor" => "blazor-ui",
    "ar-vr" => "vr-lab",
    "tech-style-guide" => "store",
    "themebuilder" => "themebuilder",
    "winui" => "win-ui",
    "unite-ux" => "unite-ux",    
    "unity-xr" => "vr-lab"
  }

  platform = site.config['platform']  
  html = open("http://cdn.telerik-web-assets.com/telerik-navigation/stable/nav-%s-csa-abs-component.html" % [navigations_map[platform]]).read
  File.write('./_includes/top-nav.html', html)

  if site.config['other_platforms']
    site.config['other_platforms'].each do |other_platform|
      html = open(navigation_url % [navigations_map[other_platform]]).read
      File.write("./_includes/top-nav-#{other_platform}.html", html)
    end
  end
end
