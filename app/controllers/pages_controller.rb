class PagesController < ApplicationController

  before_filter :build_contestant_hash, :only => [:wedding_contest_submit]
  before_filter :deny_access_for_non_admins, :only => [:admin]

  def home
    @title = "A Software Development and Video Production Firm based in Ottawa, Canada"
    @meta_description = "BiteSite is an Ottawa, Canada based company dedicated to building stylish, elegant, and robust Web and Mobile Applications and producing
                        eye-catching, professional media. It targets small to medium size businesses from start-ups to well established businesses.
                        BiteSite believes strongly in finding the right-fit customer for
                        the right-fit company to bring success to all who are invovled."
                        
    @recent_news_posts = NewsPost.published.limit(3)
    @video_listings = VideoListing.all


    @competencies = [
      {icon: "magnet" , title: "UI Design"},
      {icon: "desktop" , title: "Web Design"},
      {icon: "code" , title: "Web Development"},
      {icon: "mobile" , title: "iOS Development"},
      {icon: "mobile" , title: "Android Development"},
      {icon: "paint-brush" , title: "Graphic Design"},
      {icon: "camera-retro" , title: "Photography"},
      {icon: "video-camera" , title: "Film Production"},
      {icon: "fire" , title: "Motion Graphics"}
    ]

    @staff_listings = [
      {name: "Casey Li", position: "CEO & Founder", avatar: "casey.png"},
      {name: "Ryan O'Connor", position: "Software Developer", avatar: "ryan.png"},
      {name: "Menelik Tucker", position: "Software Developer", avatar: "tucker.png"},
      {name: "Tim Clark", position: "Filmmaker", avatar: "tim.png"}
    ]

  end

  def portfolio
    @title = "Portfolio"
  end
  
  def wedding_contest_submit
    
    @contest = Contest.find_by_name("Wedding Video 2013")
    @contestant = @contest.contestants.build(@contestant_hash)
    @success = @contestant.save
    
    AdminMailer.visitor_has_entered_contest(@contestant).deliver
    VisitorMailer.contest_confirmation(@contestant).deliver
    
    respond_to do |format|
      format.json { render json: { success: @success }.to_json }
    end
  end

  def contact
    @title = "Home"
    @success = false
    @message = ""

    if request.post?
      if !params[:email_address].blank? && !params[:message].blank?

        if EmailBlacklisting.exists?(email: params[:email_address].upcase.strip)
          @message = "Your e-mail has been blacklisted. If you want to appeal this, please contact info@bitesite.ca directly."
        else
          ContactFormSubmission.create({ first_name: params[:first_name],
                                         last_name: params[:last_name],
                                         email_address: params[:email_address],
                                         message: params[:message]
                                       })

          if params[:honey_pot].blank?
            first_name = params[:first_name]
            last_name = params[:last_name]
            customer_email = params[:email_address]
            message = params[:message]
          
            EmailJob.new.async.perform(first_name, last_name, customer_email, message)
            @success = true
          end
        end
      end
    end
    
    respond_to do |format|
      format.html { redirect_to "/"}
      format.json { render :json => { :success => @success, :message => @message }.to_json }
    end
    
  end
  
  def admin
    @title = "Admin Menu"
  end

  def faq
    @title = "FAQ"
  end

  def terms_and_conditions
    @title = "Terms and Conditions"
  end

  def setting_up_your_heroku_account
    @title = "Setting up your Heroku account"
  end

  def international_safety
    @title = "International Safety Website - Case Study"
  end

  def mydoma
    @title = "Mydoma Studio Video - Case Study"
  end

  def ollie
    @title = "Project Ollie Web Application - Case Study"
  end

  def lspark_grad
    @title = "L-SPARK Grad Video - Case Study"
  end

  def lspark
    @title = "L-SPARK - Case Study"
  end

  def d3m
    @title = "Teldio D3M - Case Study"
  end

  def martello
    @title = "Martello All Devices Video - Case Study"
  end

  def solink
    @title = "Solink Explainer Video - Case Study"
  end

  def christine_kelly
    @title = "Christine Kelly PHD Web Application"
  end
  
  def filefacets
    @title = "FileFacets How it works Video"
  end

  private
  
  def build_contestant_hash
    if params[:newsletter] == "true"
      newsletter_text = "Interested in BiteSite Newsletter"
      register_mailchimp_user_for_newsletter(params[:first_name], params[:last_name], params[:email])
    else
      newsletter_text = "Not Interested in BiteSite Newsletter"
    end
    
    notes = "#{params[:wedding_date]} / #{params[:wedding_location]} / #{params[:message]} / #{newsletter_text}"
    @contestant_hash = { first_name: params[:first_name], last_name: params[:last_name], email: params[:email], notes: notes }    
  end

end
