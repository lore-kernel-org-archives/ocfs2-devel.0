From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 08 Oct 2008 09:56:41 +0800
Subject: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute
	support
In-Reply-To: <20081007220811.GG26373@wotan.suse.de>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>	<1222293680-15451-14-git-send-email-mfasheh@suse.com>	<20081002081644.GB24717@lst.de>
	<20081007220811.GG26373@wotan.suse.de>
Message-ID: <48EC1359.6040109@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
>>> +static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
>>> +{
>>> +	struct xattr_handler *handler = NULL;
>>> +
>>> +	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
>>> +		handler = ocfs2_xattr_handler_map[name_index];
>>> +
>>> +	return handler;
>>> +}
>> You seem to need the handler mostly for getting back to the prefix
>> from the handler.  This is a pretty clear indicator that you don't
>> want to use the xattr_handler splitting but deal with the whole
>> attr name.  Take a look at the btrfs code after my recent xattr changes
>> on how to handle this more nicely.
> 
> Tao, Can you look into this?

I have looked the patch for btrfs about this. We are different.
Btrfs store the whole xattr name including the prefix "user." 
"trusted.", we store index number instead of it.

regards,
tiger
