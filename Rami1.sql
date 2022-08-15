update d_play_list_items set comments='After graduation' where song_id='46';
select * from d_play_list_items;
select * from d_cds where year=(select min(year)from d_cds);