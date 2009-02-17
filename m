From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 16 Feb 2009 22:00:22 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use the right access_* method in
	ctime update	of xattr.
In-Reply-To: <499A5174.90008@oracle.com>
References: <1234816768-8571-1-git-send-email-tao.ma@oracle.com>
	<20090217054449.GC5489@mail.oracle.com> <499A5174.90008@oracle.com>
Message-ID: <20090217060022.GE5489@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 17, 2009 at 01:56:04PM +0800, Tao Ma wrote:
>> 	Eek!  How did tristan's and my testing miss this?  Mark, this is
>> a bugfix for .29.
> actually tristan's test case found this and I just don't have time to  
> investigate on it until now.  
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1065
>
> Thank you, tristan.

	Oh, awesome.  Thank you, tristan, indeed!  Perhaps the patch
needs a Reported-by: Tristan... tag.

Joel

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
