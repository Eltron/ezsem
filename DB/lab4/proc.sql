create or alter procedure stowage as
declare variable id_ord int;
declare variable id_used_ord int;
declare variable id_trans int;
declare variable id_transportation int = -1;
declare variable quantity int = 0;
declare variable load_quant int = 0;
declare variable weight int;
declare variable total_weight int;
declare variable capacity int;

begin
    id_transportation = (select max(id) from transportation);
    
    for select id from transport where transport.id in (select id_transport from transportation) into :id_trans do
    begin
        capacity = (select capacity from transport where id = :id_trans);
		
        for select id_ord from transportation where id_transport = :id_trans into :id_used_ord do
        begin
            load_quant = (select load_quant from transportation where id_ord = :id_used_ord and id_transport = :id_trans);
            weight = (select weight from load, ord where ord.id = :id_used_ord and load.id = ord.id_load);
            capacity = :capacity - :load_quant * :weight;
        end
		
		load_quant = 0;
		
        if(:capacity > 0) then
        begin
            if(:quantity > 0) then
            begin
				weight = :total_weight/:quantity;
                if(:capacity >= :total_weight) then
                begin
                    capacity = :capacity - :total_weight;
					load_quant = :quantity;
                    quantity = 0;
                end
                else if(:capacity >= :weight) then
                    while(:quantity > 0) do
                    begin
                        capacity = :capacity - :weight;
                        
                        if(:capacity < 0) then break;
						
                        load_quant = :load_quant + 1;
                        quantity = :quantity - 1;
                    end
                
                if(:total_weight > :quantity * :weight) then
                begin
                    total_weight = :quantity * :weight;
                    id_transportation = :id_transportation + 1;
                    insert into transportation(id, id_transport, id_ord, load_quant) values (:id_transportation, :id_trans, :id_ord, :load_quant);
                end
            end
        
            if(:quantity = 0) then
                for select id from ord where ord.id not in (select id_ord from transportation) into :id_ord do
                begin
                    quantity = (select quantity from ord where id = :id_ord);
                    weight = (select weight from load, ord where ord.id = :id_ord and load.id = ord.id_load);
                    total_weight = :quantity * :weight;
                    
                    if(:capacity >= :total_weight) then
                    begin
                        capacity = :capacity - :total_weight;
						load_quant = :quantity;
                        quantity = 0;
                    end
                    else if(:capacity >= :weight) then
                        while(:quantity > 0) do
                        begin
                            capacity = :capacity - :weight;
                            
                            if(:capacity < 0) then break;
							
                            load_quant = :load_quant + 1;
                            quantity = :quantity - 1;
                        end
                    
                    if(:total_weight > :quantity * :weight) then
                    begin
                        total_weight = :quantity * :weight;
                        id_transportation = :id_transportation + 1;
                        insert into transportation(id, id_transport, id_ord, load_quant) values (:id_transportation, :id_trans, :id_ord, :load_quant);
                    end
                    
                    if(:capacity <= 0) then break;
                end
        end
    end

    for select id from transport where transport.id not in (select id_transport from transportation) into :id_trans do
    begin
        capacity = (select capacity from transport where id = :id_trans);
		load_quant = 0;
		
        if(:quantity > 0) then
        begin
            if(:capacity >= :total_weight) then
            begin
                capacity = :capacity - :total_weight;
				load_quant = :quantity;
                quantity = 0;
            end
            else if(:capacity >= :weight) then
                while(:quantity > 0) do
                begin
                    capacity = :capacity - :weight;
                    
                    if(:capacity < 0) then break;
                    
					load_quant = :load_quant + 1;
                    quantity = :quantity - 1;
                end
            
            if(:total_weight > :quantity * :weight) then
            begin
                total_weight = :quantity * :weight;
                id_transportation = :id_transportation + 1;
                insert into transportation(id, id_transport, id_ord, load_quant) values (:id_transportation, :id_trans, :id_ord, :load_quant);
            end
        end
    
        if(:quantity = 0) then
            for select id from ord where ord.id not in (select id_ord from transportation) into :id_ord do
            begin
                quantity = (select quantity from ord where id = :id_ord);
                weight = (select weight from load, ord where ord.id = :id_ord and load.id = ord.id_load);
                total_weight = :quantity * :weight;
                
                if(:capacity >= :total_weight) then
                begin
                    capacity = :capacity - :total_weight;
					load_quant = :quantity;
                    quantity = 0;
                end
                else if(:capacity >= :weight) then
                    while(:quantity > 0) do
                    begin
                        capacity = :capacity - :weight;
                        
                        if(:capacity < 0) then break;
                        
						load_quant = :load_quant + 1;
                        quantity = :quantity - 1;
                    end
                
                if(:total_weight > :quantity * :weight) then
                begin
                    total_weight = :quantity * :weight;
                    id_transportation = :id_transportation + 1;
                    insert into transportation(id, id_transport, id_ord, load_quant) values (:id_transportation, :id_trans, :id_ord, :load_quant);
                end
                
                if(:capacity <= 0) then break;
            end
    end
end
