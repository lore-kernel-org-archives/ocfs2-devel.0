From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 29 Jul 2008 15:23:02 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2-tools: Add extended
	attribute	support in mkfs.ocfs2
In-Reply-To: <488EAF80.1070207@oracle.com>
References: <1216969599-9280-1-git-send-email-tiger.yang@oracle.com>
	<20080725093315.GF6317@ca-server1.us.oracle.com>
	<488EAF80.1070207@oracle.com>
Message-ID: <20080729222302.GC11710@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 29, 2008 at 01:49:52PM +0800, Tiger Yang wrote:
> Joel Becker wrote:
> 
> >> +struct ocfs2_xattr_entry {
> >> +	__le32	xe_name_hash;
> >> +	__le16	xe_name_offset;
> >> +	__u8	xe_name_len;
> >> +	__u8	xe_type : 7;
> >> +	__u8	xe_local : 1;
> >> +	__le64	xe_value_size;
> >> +};
> > 
> > 	We removed the bitfields.
> 
> Do we really remove the bitfields? We have no space for new u8 in 
> xattr_entry.
> Mark said we just need change the bottom bit for xe_local.

	We don't add an extra u8.  We just define the single u8 and will
use masking to flag out the local bit.

Here's the structure:

struct ocfs2_xattr_entry {
	__le32	xe_name_hash;
	__le16	xe_name_offset;
	__u8	xe_name_len;
	__u8	xe_type;
	__le64	xe_value_size;
};


And you'd access xe_type with something like this:

static inline int xe_get_type(struct ocfs2_xattr_entry *xe)
{
	return xe->xe_type & 0xFE;
}

static inline int xe_is_local(struct ocfs2_xattr_entry *xe)
{
	return xe->xe_type & 0x01;
}

	Something like that.  Mark might have a preferred way to create
the accessor functions.  The point is, defining the bitfields (:7, :1)
isn't a portable thing to do for on-disk structures.

Joel

-- 

"I'm so tired of being tired,
 Sure as night will follow day.
 Most things I worry about
 Never happen anyway."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
