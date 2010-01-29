From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 29 Jan 2010 13:53:43 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not downconvert if the lock
 level is already compatible
In-Reply-To: <20100129214642.GC30409@mail.oracle.com>
References: <1264787051-7491-1-git-send-email-sunil.mushran@oracle.com>
	<20100129181409.GV11402@wotan.suse.de>
	<20100129214642.GC30409@mail.oracle.com>
Message-ID: <4B6358E7.2000701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Jan 29, 2010 at 10:14:09AM -0800, Mark Fasheh wrote:
>> Hmm, looks like it's the month of dlmglue fixes?  :)
>
> 	fs/dlm is far more asynchronous than o2dlm, and boy it shows us
> up ;-)

True. In this case, it is bast-ing even before the ast. ;)
