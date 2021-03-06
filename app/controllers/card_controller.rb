class CardController < ApplicationController

  def new
    @categories = Category.eager_load(children: :children).where(ancestry: nil)
    card = Card.where(user_id: current_user.id)
    redirect_to card_path(card) if card.exists?
  end

  def pay #payjpとCardのデータベース作成を実施
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    if params['payjp-token'].blank?
      redirect_to new_card_path
    else
      customer = Payjp::Customer.create(
        description: '登録テスト', 
        email: current_user.email, 
        card: params['payjp-token'],
        metadata: {user_id: current_user.id}
      )
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to card_path(current_user.id)
      else
        redirect_to pay_card_index_path
      end
    end
  end

  def delete #PayjpとCardデータベースを削除
    card = Card.find_by(user_id: current_user.id)
    if card.present?
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      customer.delete
      card.delete
    end
      redirect_to new_card_path
  end

  def show #Cardのデータpayjpに送り情報を取り出す
    @categories = Category.eager_load(children: :children).where(ancestry: nil)
    card = Card.find_by(user_id: current_user.id)
    if card.present?
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
      @card_brand = @default_card_information.brand 
      case @card_brand
      when "Visa"
        @card_src = "card_logo_visa.png"
      when "MasterCard"
        @card_src = "card_logo_master.png"
      when "Saison"
        @card_src = "card_logo_saisonr.png"
      when "JCB"
        @card_src = "card_logo_jcb.gif"
      when "American Express"
        @card_src = "card_logo_amex.gif"
      when "Diners Club"
        @card_src = "card_logo_diners.png"
      when "Discover"
        @card_src = "card_logo_discover.jpg"
      end
    else
      redirect_to new_card_path
    end
  end

end