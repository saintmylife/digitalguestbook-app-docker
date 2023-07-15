class DisplaysController < ApplicationController

	def update
	    @display = Display.find(1)

	    begin
	        	 @display.update_attributes(
						 alamat:params[:display][:alamat].present? ? true : false,
						kota:params[:display][:kota].present? ? true : false,
						 nomor_ponsel:params[:display][:nomor_ponsel].present? ? true : false,
	      		 kategori:params[:display][:kategori].present? ? true : false,
						 status:params[:display][:status].present? ? true : false,
						 nama_meja:params[:display][:nama_meja].present? ? true : false,
						 jumlah_undangan:params[:display][:jumlah_undangan].present? ? true : false,
	           jabatan:params[:display][:jabatan].present? ? true : false
		    		 )
			#
	    #    	@dis_array = []
	    #     i = 1
			#
		  #   while i <= 13  do
		  #   	@dis_array.push("alamat") if i==1 && @display.alamat == true
		  #   	@dis_array.push("nomor_ponsel") if i==2 && @display.nomor_ponsel == true
		  #   	@dis_array.push("kategori") if i==3 && @display.kategori == true
		  #   	@dis_array.push("status") if i==4 && @display.status == true
		  #   	@dis_array.push("nama_meja") if i==5 && @display.nama_meja == true
		  #   	@dis_array.push("jumlah_undangan") if i==11 && @display.jumlah_undangan == true
		  #   	@dis_array.push("jabatan") if i==12 && @display.jabatan == true
			# i += 1
			#end

			@con = true
			respond_to do |format|
				format.js { render 'displays/index' }
			end
	    rescue
	      @con = false
	      respond_to do |format|
	        format.js { render 'displays/index' }
	      end
	    end

	end
end
