From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 18 Jun 2010 09:37:49 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <20100618023738.GA2483@laptop.us.oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<20100616060615.GB2895@laptop.us.oracle.com>
	<4C1A3A05.10704@oracle.com>
	<20100618023738.GA2483@laptop.us.oracle.com>
Message-ID: <4C1BA0DD.80007@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/17/2010 07:37 PM, Wengang Wang wrote:
> On 10-06-17 08:06, Sunil Mushran wrote:
>    
>> On 06/15/2010 11:06 PM, Wengang Wang wrote:
>>      
>>> still the question.
>>> If you have sent DEREF request to the master, and the lockres became in-use
>>> again, then the lockres remains in the hash table and also in the purge list.
>>> So
>>> 1) If this node is the last ref, there is a possibility that the master
>>> purged the lockres after receiving DEREF request from this node. In this
>>> case, when this node does dlmlock_remote(), the lockres won't be found on the
>>> master. How to deal with it?
>>>
>>> 2) The lockres on this node is going to be purged again, it means it will send
>>> secondary DEREFs to the master. This is not good I think.
>>>
>>> A thought is setting lockres->owner to DLM_LOCK_RES_OWNER_UNKNOWN after
>>> sending a DEREF request againt this lockres. Also redo master reqeust
>>> before locking on it.
>>>        
>> The fix we are working towards is to ensure that we set
>> DLM_LOCK_RES_DROPPING_REF once we are determined
>> to purge the lockres. As in, we should not let go of the spinlock
>> before we have either set the flag or decided against purging
>> that resource.
>>
>> Once the flag is set, new users looking up the resource via
>> dlm_get_lock_resource() will notice the flag and will then wait
>> for that flag to be cleared before looking up the lockres hash
>> again. If all goes well, the lockres will not be found (because it
>> has since been unhashed) and it will be forced to go thru the
>> full mastery process.
>>      
> That is ideal.
> In many cases the lockres is not got via dlm_get_lock_resource(), but
> via dlm_lookup_lockres()/__dlm_lookup_lockres, which doesn't set the new
> IN-USE state, directly. dlm_lookup_lockres() takes and drops
> dlm->spinlock. And some of caller of __dlm_lookup_lockres() drops the
> spinlock as soon as it got the lockres. Such paths access the lockres
> later after dropping dlm->spinlock and res->spinlock.
> So there is a window that dlm_thread() get a chance to take the
> dlm->spinlock and res->spinlock and set the DROPPING_REF state.
> So whether new users can get the lockres depends on how "new" it is. If
> finds the lockres after DROPPING_REF state is set, sure it works well. But
> if it find it before DROPPING_REF is set, it won't protect the lockres
> from purging since even it "gets" the lockres, the lockres can still in
> unused state.
>    

dlm_lookup_lockres() and friends just looks up the lockres hash.
dlm_get_lock_resource() also calls it. It inturn is called by dlmlock()
to find and/or create lockres and create a lock on that resource.

The other calls to dlm_lookup_lockres() are from handlers and those
handlers can only be tickled if a lock already exists. And if a lock
exits, then we cannot be purging the lockres.

The one exception is the create_lock handler and that only comes
into play on the lockres master. The inflight ref blocks removal of
such lockres in the window before the lock is created.

DROPPING_REF is only valid for non-master nodes. As in, only
a non-master node has to send a deref message to the master node.

Confused? Well, I think this needs to be documented. I guess I will
do that after I am done with the global heartbeat business.

Sunil
