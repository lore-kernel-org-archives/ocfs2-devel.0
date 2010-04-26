From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 26 Apr 2010 15:24:23 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered v3
In-Reply-To: <201004171749.10674.lidongyang@novell.com>
References: <201004171749.10674.lidongyang@novell.com>
Message-ID: <20100426222423.GJ17377@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Apr 17, 2010 at 05:49:10PM +0800, Li Dongyang wrote:
> when we fall back to buffered write from direct write, we call
> __generic_file_aio_write but that will end up doing direct write
> even we are only prepared to do buffered write because the file
> has O_DIRECT flag set. This is a fix for
> https://bugzilla.novell.com/show_bug.cgi?id=591039
> revised with Joel's comments.
> 
> Signed-off-by: Li Dongyang <lidongyang@novell.com>

	This looks good to me.  I'd like Mark's ack before I push it to
merge-window.

Joel

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
