include FirePoll

def view_invite(invite)
  visit "/sign_up/#{invite.code}"
end

def submit_signup
  click_button("Sign up")
end

def submit_invite
  click_button "Submit"
end

def login(email, password="password")
  fill_in("user_email", with: email)
  fill_in("user_password", with: password)
  click_button("Sign in")
  sleep 1
end

def view_sign_in
  visit new_user_session_path
end

def open_settings
  page.find('.app-current-user').click
end

def visit_profile_for(user)
  visit "/user/#{user.id}"
end

def view_root
  visit root_path
end

def search_feed(search_term)
  fill_in("app-query", with: search_term)
  click_button("app-search")
end

def view_it
  save_and_open_page
  screenshot_and_open_image
end

def view_article(article)
  page.find(".app-article-#{article.id}.app-view-article" ).click
end

def handle_confirm_dialog(accept=true)
  page.evaluate_script "window.original_confirm_function = window.confirm"
  page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
  yield
ensure
  page.evaluate_script "window.confirm = window.original_confirm_function"
end

def view_collection(collection)
  visit "/collections/#{collection.id}"
end
