From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 28 Aug 2009 15:00:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlogs to aops.c -V3
In-Reply-To: <20090828053911.GB19658@mail.oracle.com>
References: <200908140604.n7E64rhS031970@acsinet15.oracle.com>
	<20090828011018.GG18962@mail.oracle.com>
	<4A973D1D.70500@oracle.com>
	<20090828053911.GB19658@mail.oracle.com>
Message-ID: <4A978098.60306@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Joel Becker wrote:
> On Fri, Aug 28, 2009 at 10:12:45AM +0800, Wengang Wang wrote:
>> in fact, I had ever hit case that ocfs2 returns EIO, but even allowing 
>> ENTRY/EXIT, there is no log indicating that.. the bug number is 8627756.
>>
>> So I think we'd better add the logs to such functions. and added them 
>> for the functions in aops.c(seems that Sunil wants to add logs to that 
>> file)...
> 
> 	Hunting down an -EIO is a good case, though we usually use
> mlog_errno() for that.  The concern I have is not that you're logging,
> it's that entry/exit are pretty poor things to log.
> 	For example, once you figure out where the -EIO is coming from,
> I'd rather see us properly log that.
> 

Yes, we should log errors when we hit them immediately(if you meant that).

and I think I did added mlog_errno()s where there should be one but 
there is a lack. for example:

  	ret = ocfs2_inode_lock_full(inode, NULL, 0, OCFS2_LOCK_NONBLOCK);
-	if (ret)
-		return err;
+	if (ret) {
+		mlog_errno(ret);
+		goto bail;
+	}

the thing is that I only checked file apos.c, maybe there are more such 
lacks..

>> and for the patch its self, I think the log contents are for developers 
>> to check(not for customer to view), so we can know what are printed by 
>> checking the src... so I am printing some parameters without pointing 
>> out what they are.
> 
> 	Yeah, I just don't know that we care :-
Oh, excuse for my poor English :P, what do you mean here?
you think it's OK that we don't point out what are printed? or you think 
we should point them out exactly in log contents?

regards,
wengang.
