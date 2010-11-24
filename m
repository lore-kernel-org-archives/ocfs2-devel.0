From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 23 Nov 2010 16:22:26 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: Migrate lockres with no
 locks if it has a reference
In-Reply-To: <20101121195713.GC14333@mail.oracle.com>
References: <1290208010-2603-1-git-send-email-sunil.mushran@oracle.com>
	<1290208010-2603-2-git-send-email-sunil.mushran@oracle.com>
	<20101121195713.GC14333@mail.oracle.com>
Message-ID: <4CEC5AC2.40003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/21/2010 11:57 AM, Joel Becker wrote:
>>   static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
>>   				      struct dlm_lock_resource *res,
>> -				      int *numlocks)
>> +				      int *numlocks,
>> +				      int *hasrefs)
> 	There's no point in returning hasrefs.  No caller cares about
> *why* it isn't migratable, just that it isn't.  In fact, no caller cares
> about the number of locks, either.  They only care about the boolean
> is/is-not migratable.
> 	I say you remove the numlocks and hasref arguments, and merely
> return 0 when there are locks or refs, 1 otherwise.  -errno for errors,
> of course.

Agreed.

I found further potential for cleanup. My suggestion would be take this
patch as-is as a bug fix. The next patch will have the cleanup.
