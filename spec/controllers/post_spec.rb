require 'spec_helper'
describe PostsController do

let(:user){FactoryGirl.create :user}
let(:my_question){FactoryGirl.create :question}
let(:my_answer){FactoryGirl.create :answer, question: my_question}
let(:attribs){FactoryGirl.attributes_for :post, body: "dat update"}
let(:answer_attribs){FactoryGirl.attributes_for :post, question_id: 1}

  context "#index" do
    before(:each){ get :index }
    it{ returns_valid_response }
    it "should assign @posts to every post that is a question" do
      expect(assigns(:questions)).to eq Post.where(question_id: nil)
    end
  end

  context '#show' do
    context "when :id is the id of a question" do
    before(:each){ get :show, id: my_question.id }
      it{ returns_valid_response }
      it "it should assign @question to my_question" do
        expect(assigns(:question)).to eq my_question
      end
    end

    context "when :id is invalid" do
      before(:each){ get :show, id: "red" }
      it { returns_valid_redirect }
    end
  end

  context '#edit' do
    before(:each){ session[:user_id] = user.id }
    context "when editting a question" do
      before(:each){ get :edit, id: my_question.id }
      it{ returns_valid_response }
      it "it should assign @question to my_question" do
        expect(assigns(:post)).to eq my_question
      end
    end

    context "when editting an answer" do
      before(:each){ get :edit, id: my_answer.id }
      it{ returns_valid_response }
      it "it should assign @question to my_answer" do
        expect(assigns(:post)).to eq my_answer
      end
    end
  end

  context '#new' do
    before(:each){ session[:user_id] = user.id }
    context "when creating a question" do
      before(:each){ get :new }
      it { returns_valid_response }
      it "it should create a new instance of post" do
        expect(assigns :post).to be_a_new Post
      end
    end
  end

  context '#update' do
    before(:each){ session[:user_id] = user.id }
    context 'when updating a question' do
      context 'with valid params' do
        before(:each){ put :update, id: my_question.id, post: {body: attribs[:body]} }
        it { returns_valid_redirect }
        it "should update a post" do
          expect{
            my_question.reload.body
            }.to change{my_question.body}.to(attribs[:body])
        end
      end

      context 'with invalid params' do
        before(:each){ put :update, id: my_question.id, post: {body: ""} }
        it { returns_valid_redirect }
        it "should not update a post" do
          expect{
            my_question.reload.body
            }.to_not change{my_question.body}
        end
      end
    end

    context 'when updating a answer' do
      context 'with valid params' do
        before(:each){ put :update, id: my_answer.id, post: {body: attribs[:body]} }
        it { returns_valid_redirect }
        it "should update a post" do
          expect{
            my_answer.reload.body
            }.to change{my_answer.body}.to(attribs[:body])
        end
      end


      context 'with invalid params' do
        before(:each){ put :update, id: my_answer.id, post: {body: ""} }
        it { returns_valid_redirect }
        it "should not update a post" do
          expect{
            my_answer.reload.body
            }.to_not change{my_answer.body}
        end
      end
    end
  end

  context "#create" do
    context 'creating a question' do
    before(:each){ session[:user_id] = user.id }

      context "with valid params" do
        it "should be redirect" do
          post :create, post: attribs
          expect(response).to be_redirect
        end

        it "should be of the class 'Question'" do
          post :create, post: attribs
          expect(assigns(:post)).to be_a(Question)
        end

        it "should increase the Post count" do
          expect{
            post :create, post: attribs
          }.to change{Post.count}.by(1)
        end
      end
    end

    context 'creating an answer' do
    before(:each){ session[:user_id] = user.id }

      context "with valid params" do
        before(:each){my_question}

        it "should be redirect" do
          post :create, post: answer_attribs
          expect(response).to be_ok
        end

        it "should be of the class 'Answer'" do
          post :create, post: answer_attribs
          expect(assigns(:post)).to be_a(Answer)
        end

        it "should increase the Post count" do
          expect{
            post :create, post: answer_attribs
          }.to change{Post.count}.by(1)
        end
      end
    end
  end

  context '#favorite' do
    before(:each){
      session[:user_id] = user.id
      put :favorite, id: my_question.id, answer: my_answer.id
    }
    it {returns_valid_redirect}
    it "updates the answer's question's favorite_id" do
      expect{
        my_answer.question.reload.favorite_id
        }.to change{my_answer.question.favorite_id}.to(my_answer.id)
    end

    it "should assign @answer to the answer" do
      expect(assigns :answer).to eq my_answer
    end
  end
end
