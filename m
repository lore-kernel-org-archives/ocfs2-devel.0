From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jul 27 22:53:00 2004
Subject: [Ocfs2-devel] A patch to improve the metadata reading
	throughput(a gainst svn1267)
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404F680EA@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8404F680EA@pdsmsx403>
Message-ID: <20040728035254.GA3499@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jul 24, 2004 at 07:40:52AM +0800, Ling, Xiaofeng wrote:
> Yes, I've run test, it's ok now.
> So currently, when the node get READONLY message, it will 
> flush the journal and then answer it. Is my description correct?
More specifically, it'll tell the node to try again and kick the commit
thread, which will flush the journal and drop any locks on it. Usually, by
the time the other node asks again, the lock is free and we can turn it into
a readonly lock.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
