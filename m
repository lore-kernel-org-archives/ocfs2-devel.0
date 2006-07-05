From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 5 Jul 2006 11:32:04 -0700
Subject: [Ocfs2-devel] ocfs2-tools-1.2.0-1 compile error
In-Reply-To: <12802.83.31.18.200.1152035748.squirrel@webmail.piekna.pl>
References: <12802.83.31.18.200.1152035748.squirrel@webmail.piekna.pl>
Message-ID: <20060705183204.GS11640@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 04, 2006 at 07:55:48PM +0200, boka wrote:
> i want to install ocfs2-tools-1.2.0-1 on slackware 10.2 (up-to-date) with
> 2.6.17.2 kernel and i got error:
> 
> ./configure
<snip>
> checking for com_err... yes
> checking COM_ERR_CFLAGS... -I/include
> checking COM_ERR_LIBS... -L/lib -lcom_err
<snip>
> root at node1:~/ocfs2/ocfs2-tools-1.2.1# make
> make -C libo2dlm
> make[1]: Entering directory `/root/ocfs2/ocfs2-tools-1.2.1/libo2dlm'
> compile_et o2dlm_err.et
> make[1]: compile_et: Command not found
> make[1]: *** [o2dlm_err.h] Error 127
> make[1]: Leaving directory `/root/ocfs2/ocfs2-tools-1.2.1/libo2dlm'
> make: *** [libo2dlm] Error 2

	compile_et is a binary that comes with libcom_err, which is part
of e2fsprogs.  Generally, it is included in the development package for
libcom_err (eg "comerr-dev" on Debian, "e2fsprogs-devel" for Red Hat,
etc).  Clearly you have something approximating this, as you have the
com_err headers and libcom_err.so.  However, something in your install
has not included compile_et.  Find out what includes that, install it,
and you're good to go.

Joel

-- 

"There is shadow under this red rock.
 (Come in under the shadow of this red rock)
 And I will show you something different from either
 Your shadow at morning striding behind you
 Or your shadow at evening rising to meet you.
 I will show you fear in a handful of dust."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
