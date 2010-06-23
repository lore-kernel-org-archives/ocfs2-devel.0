From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 23 Jun 2010 12:05:45 -0700
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <AANLkTilk1YjhLjRectGjzgTKpK4bBeQlKj1Y_9F110bx@mail.gmail.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>	<4C1B9968.6020805@oracle.com>
	<AANLkTilk1YjhLjRectGjzgTKpK4bBeQlKj1Y_9F110bx@mail.gmail.com>
Message-ID: <4C225B09.7000903@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/23/2010 11:25 AM, Goldwyn Rodrigues wrote:
>>> +void ocfs2_dentry_attach_gen(struct dentry *dentry)
>>> +{
>>> +       int *gen = (int *)kmalloc(sizeof(int), GFP_KERNEL);
>>> +       *gen = OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
>>> +       /* Generation numbers are specifically for negative dentries */
>>> +       if (dentry->d_inode)
>>> +               BUG();
>>> +       dentry->d_fsdata = (void *)gen;
>>> +}
>>> +
>>>
>>>        
>> kmalloc()s can fail. If this is just an int, why not just store it
>> directly in d_fsdata. Add appropriate casts.
>>      
> This will cause compilation warnings for either x86_64 or i686 systems
> depending on the data type we choose. I will do this anyways.
>    

See if you can silence the warning. My main problem here is that
we don't handle the error case. So if kmalloc() is seen as the best
solution, go ahead use it, but do handle the ENOMEM case.

>> Also, are you sure about the locking when reading the parent's
>> generation.
>>      
> No, what lockings do you suspect might be required?
>    

Can we race with the data convert worker. It is a increment only.
So should not matter. But I'll need to think about this more.
