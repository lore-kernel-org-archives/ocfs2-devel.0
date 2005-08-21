From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun Aug 21 23:01:58 2005
Subject: [Ocfs2-devel] Small fixes for ocfs2-tools 1.1.1
In-Reply-To: <20050820141934.GM4436@marowsky-bree.de>
References: <20050820141934.GM4436@marowsky-bree.de>
Message-ID: <20050822040159.GH3168@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Aug 20, 2005 at 04:19:34PM +0200, Lars Marowsky-Bree wrote:
> The second one I'm not sure about whether you want to take it upstream.
> If linking against com_err, you need to also link against pthread now.

	I'm so tired of arbitrary "punish the 99% of users who are sane
by pulling in threads, which are only used by 1% of folks" patches.
Then you have harder compatibility issues, and you have larger run sets,
and you have whack stuff going on when debugging...
 
> In our specfile, I also had to move debugfs.ocfs2 and ocfs2cdsl from
> /sbin to /usr/sbin, because they link against glib, which is not on /,
> and thus our build system doesn't like binaries on / linked against
> that.

	Oh, you mean distro A puts thing in different and more
surprising place than distro B?  That _never_ happens in Linux! :-)

Joel

-- 

"The only way to get rid of a temptation is to yield to it."
         - Oscar Wilde 

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
