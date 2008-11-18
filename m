From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 Nov 2008 15:03:12 -0800
Subject: [Ocfs2-devel] [Patch 1/3] ocfs2-tools: Resolve rpmlint	warnings
	in init scripts
In-Reply-To: <B7D332FF-F786-4DBD-862D-8ED8CCE441A9@suse.de>
References: <B7D332FF-F786-4DBD-862D-8ED8CCE441A9@suse.de>
Message-ID: <20081118230312.GB10451@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 18, 2008 at 11:18:38AM +0100, Andrew Beekhof wrote:
> Fix a number of LSB compliance issues reported by rpmlint regarding  
> ocfs2 init scripts
> 
> Signed-off-by: Andrew Beekhof <abeekhof@suse.de>
> 
> --- upstream/vendor/common/o2cb.init.sh	2008-09-11 16:51:11.000000000  
> +0200
> +++ dev/vendor/common/o2cb.init.sh	2008-10-23 14:36:49.000000000 +0200
> @@ -8,7 +8,8 @@
>   # Provides: o2cb
>   # Required-Start: $network
>   # Should-Start:
> -# Required-Stop:
> +# Should-Stop:
> +# Required-Stop: $null

	Really, rpmlint requires everyone to know some magic $null?  Who
the heck thought that one up?  Is it portable to all distros?

Joel

-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
