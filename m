From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 12 Jul 2010 11:05:22 -0400
Subject: [Ocfs2-devel] [PATCH] Cleancache: shim to Xen Transcendent
	Memory
In-Reply-To: <20100708164208.GA11763@ca-server1.us.oracle.com>
References: <20100708164208.GA11763@ca-server1.us.oracle.com>
Message-ID: <20100712150522.GD5358@phenom.dumpdata.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com

On Thu, Jul 08, 2010 at 09:42:08AM -0700, Dan Magenheimer wrote:
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

One nitpick:
..
> +
> +int tmem_enabled;
> +
> +static int __init enable_tmem(char *s)
> +{
> +	tmem_enabled = 1;
> +	return 1;
> +}
> +
> +__setup("tmem", enable_tmem);

Perhaps 'tmem_setup' is more appropiate as it might be that this
function in the future would be only used to disable tmem, not actually
enable it?

Otherwise, it has been reviewed by me.
