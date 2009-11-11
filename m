From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 10 Nov 2009 19:13:14 -0800
Subject: [Ocfs2-devel] [PATCH 10/10] ocfs2: Handle different f_version
 types
In-Reply-To: <1257818413-32014-11-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
	<1257818413-32014-11-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091111031313.GE17774@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 09, 2009 at 06:00:13PM -0800, Sunil Mushran wrote:
> Mainline commit 2b47c3611de05c585e2d81204f6c7e3e255a3461 changed type of
> file->f_version from unsigned long to u64. This patch allows building with
> kernels having either definition. Build fails if the type is something else.

	I was trying to come up with a way to not create f_version_t.
You know, pass around a u64 and cast it when comparing to
inode->i_version.  But I'm not terribly happy with that, so I guess we
leave f_version_t.  Please reorganize it so that kapi-include/ is not
needed for mainline.

Joel

-- 

"In the beginning, the universe was created. This has made a lot 
 of people very angry, and is generally considered to have been a 
 bad move."
        - Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
