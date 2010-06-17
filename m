From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 17 Jun 2010 08:06:45 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <20100616060615.GB2895@laptop.us.oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<20100616060615.GB2895@laptop.us.oracle.com>
Message-ID: <4C1A3A05.10704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/15/2010 11:06 PM, Wengang Wang wrote:
> still the question.
> If you have sent DEREF request to the master, and the lockres became in-use
> again, then the lockres remains in the hash table and also in the purge list.
> So
> 1) If this node is the last ref, there is a possibility that the master
> purged the lockres after receiving DEREF request from this node. In this
> case, when this node does dlmlock_remote(), the lockres won't be found on the
> master. How to deal with it?
>
> 2) The lockres on this node is going to be purged again, it means it will send
> secondary DEREFs to the master. This is not good I think.
>
> A thought is setting lockres->owner to DLM_LOCK_RES_OWNER_UNKNOWN after
> sending a DEREF request againt this lockres. Also redo master reqeust
> before locking on it.
>    

The fix we are working towards is to ensure that we set
DLM_LOCK_RES_DROPPING_REF once we are determined
to purge the lockres. As in, we should not let go of the spinlock
before we have either set the flag or decided against purging
that resource.

Once the flag is set, new users looking up the resource via
dlm_get_lock_resource() will notice the flag and will then wait
for that flag to be cleared before looking up the lockres hash
again. If all goes well, the lockres will not be found (because it
has since been unhashed) and it will be forced to go thru the
full mastery process.
