prefixCounter = function () {
    return db.phones.aggregate([ 
            {$group: {_id: "$components.prefix", Number_Phones: {$sum: 1}}}
        ]);
  }
  
  