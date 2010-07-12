From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 12 Jul 2010 15:24:13 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2 fix o2dlm dlm run purgelist(bug
 9094491) - rev3
In-Reply-To: <20100712182117.GA12179@mail.oracle.com>
References: <1277272108-3160-1-git-send-email-srinivas.eeda@oracle.com>
	<20100712182117.GA12179@mail.oracle.com>
Message-ID: <4C3B960D.2010806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Jun 22, 2010 at 10:48:28PM -0700, Srinivas Eeda wrote:
>   
>> +	if (!__dlm_lockres_unused) {
>> +		mlog(ML_ERROR, "found lockres %s:%.*s: in use after deref\n",
>> +		     dlm->name, res->lockname.len, res->lockname.name);
>> +		__dlm_print_one_lock_resource(res);
>> +		BUG();
>> +	}
>>     
>
> /build/jlbec/linux-2.6/working/fs/ocfs2/dlm/dlmthread.c: In function ?dlm_purge_lockres?:
> /build/jlbec/linux-2.6/working/fs/ocfs2/dlm/dlmthread.c:203: warning: the address of ?__dlm_lockres_unused? will always evaluate as ?true?
>
> 	Was this even tested?  I'm leaving this patch out of 'fixes'
> until corrected and tested.
>   
Sorry, I had the typo while making the review changes. I ran the usual 
tests but that  didn't catch this problem. I should have payed more 
attention to the build log.

I made the change and tested it, will send you the modified patch
> Joel
>
>   
