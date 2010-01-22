From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 21 Jan 2010 18:12:53 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add extent block stealing for
 ocfs2
In-Reply-To: <20100122014316.GB23568@mail.oracle.com>
References: <> <1264066975-16815-1-git-send-email-tiger.yang@oracle.com>
	<20100122014316.GB23568@mail.oracle.com>
Message-ID: <4B5909A5.30602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Jan 21, 2010 at 05:42:55PM +0800, Tiger Yang wrote:
>   
>> -static inline void ocfs2_set_inode_steal_slot(struct ocfs2_super *osb,
>> -					      s16 slot)
>> +static inline void ocfs2_init_meta_steal_slot(struct ocfs2_super *osb)
>>  {
>>  	spin_lock(&osb->osb_lock);
>> -	osb->s_inode_steal_slot = slot;
>> +	osb->s_meta_steal_slot = OCFS2_INVALID_SLOT;
>>  	spin_unlock(&osb->osb_lock);
>> +	atomic_set(&osb->s_num_meta_stolen, 0);
>> +}
>>     
>
> 	Doesn't need to be inline.  Put it in suballoc.c.
>
>   
>> +static inline void ocfs2_set_steal_slot(struct ocfs2_super *osb,
>> +					int slot, int type)
>> +{
>> +	spin_lock(&osb->osb_lock);
>> +	if (type == INODE_ALLOC_SYSTEM_INODE)
>> +		osb->s_inode_steal_slot = slot;
>> +	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
>> +		osb->s_meta_steal_slot = slot;
>> +	spin_unlock(&osb->osb_lock);
>> +}
>>     
>
> 	Doesn't need to be inline.  Put it in suballoc.c and put an __
> in front of it.
>
>   
>> -static inline s16 ocfs2_get_inode_steal_slot(struct ocfs2_super *osb)
>> +static inline int ocfs2_get_steal_slot(struct ocfs2_super *osb, int type)
>>  {
>> -	s16 slot;
>> +	int slot = OCFS2_INVALID_SLOT;
>>  
>>  	spin_lock(&osb->osb_lock);
>> -	slot = osb->s_inode_steal_slot;
>> +	if (type == INODE_ALLOC_SYSTEM_INODE)
>> +		slot = osb->s_inode_steal_slot;
>> +	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
>> +		slot = osb->s_meta_steal_slot;
>>  	spin_unlock(&osb->osb_lock);
>>  
>>  	return slot;
>>  }
>>     
>
> 	Again regarding unline and __ prefix.

All this is good.

The get and set routines are a bit convoluted. I agree with the hiding 
of the
type by adding ocfs2_steal_meta() and  ocfs2_steal_inode(). But the get/set
routines will be better off just accepting the type.

Right now the flow is:

ocfs2_steal_resource()
+                       if (type == INODE_ALLOC_SYSTEM_INODE)
+                               ocfs2_set_inode_steal_slot(osb, slot);

ocfs2_set_inode_steal_slot()
+       return ocfs2_set_steal_slot(osb, slot, INODE_ALLOC_SYSTEM_INODE);

ocfs2_set_steal_slot()
+       if (type == INODE_ALLOC_SYSTEM_INODE)
+               osb->s_inode_steal_slot = slot;

Sunil
