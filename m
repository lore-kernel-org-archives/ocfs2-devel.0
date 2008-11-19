From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 19 Nov 2008 08:34:50 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix return value set in
	init_dlmfs_fs()
In-Reply-To: <4920F53E.5010800@suse.de>
References: <4920F53E.5010800@suse.de>
Message-ID: <20081119163450.GJ8378@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 17, 2008 at 12:38:22PM +0800, Coly Li wrote:
> In init_dlmfs_fs(), if calling kmem_cache_create() failed, the code will use return value from
> calling bdi_init(). The correct behavior should be set status as -ENOMEM before going to "bail:".

Thanks, this is in ocfs2.git now.
	--Mark


--
Mark Fasheh
