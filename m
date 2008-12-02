From: Coly Li <coyli@suse.de>
Date: Wed, 03 Dec 2008 00:37:32 +0800
Subject: [Ocfs2-devel] [nov 29] what is ocfs2_lock() used for ?
In-Reply-To: <49349CF9.5090801@oracle.com>
References: <4930FDE8.3070103@suse.de> <49349CF9.5090801@oracle.com>
Message-ID: <4935644C.3060700@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> SLES10 SP2 is shipping OCFS2 1.4 + few HASF specific patches.
> 
> If you want to see how 1.4 maps to ocfs2 in mainline, review the shortlog
> on the 1.4 git tree. It tells you the full story.
> http://oss.oracle.com/git/?p=ocfs2-1.4.git;a=summary
> 
> As Tao has already posted, ocfs2_lock() adds posix lock support, which was
> added after 1.4 was released.

I will check the information. Thanks for the helpful info :)


> Coly Li wrote:
>> Hi List,
>>
>> In Linus tree, I find ocfs2_lock() in fs/ocfs2/locks.c, this function
>> can not be found from sles10
>> sp2 tree. Also I don't find any other code calling ocfs2_lock().
>>
>> Can anybody tell me, what is ocfs2_lock() used for ?

-- 
Coly Li
SuSE PRC Labs
