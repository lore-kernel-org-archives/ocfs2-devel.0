From: Manish Singh <manish.singh@oracle.com>
Date: Wed Feb  4 17:32:04 2004
Subject: [Ocfs2-devel] [PATCH] Adding ocfs support to blkid
In-Reply-To: <20040204185952.GA13452@ca-server1.us.oracle.com>
References: <200402040838.i148cCqU002632@penguin.co.intel.com>
	<20040204185952.GA13452@ca-server1.us.oracle.com>
Message-ID: <20040204233149.GA25620@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 04, 2004 at 10:59:52AM -0800, Mark Fasheh wrote:
> Could we call it "ocfs" instead of "ocfs2" below? We will likely be bumping
> up the version number in the header for ocfs version 2 when it's released.

Yeah, call it "ocfs" and set SEC_TYPE to "ocfs1", "ocfs2", and "ntocfs"
for version 1, version 2, and windows ocfs, respectively. For ocfs1 the
major version is 1, ocfs2 is 2, and ntocfs it's >= 9.

-Manish
 
> On Wed, Feb 04, 2004 at 12:38:12AM -0800, Rusty Lynch wrote:
> > The following patch adds ocfs support to blkid.
> > 
> >     --rusty
> > 
> > # This is a BitKeeper generated patch for the following project:
> > # Project Name: Ext2 filesystem utilities
> > # This patch format is intended for GNU patch command version 2.5 or higher.
> > # This patch includes the following deltas:
> > #	           ChangeSet	1.1327  -> 1.1328 
> > #	   lib/blkid/probe.c	1.15    -> 1.16   
> > #	   lib/blkid/probe.h	1.9     -> 1.10   
> > #
> > # The following is the BitKeeper ChangeSet Log
> > # --------------------------------------------
> > # 04/02/03	rusty@stratocaster.com	1.1328
> > # Adding support for the Oracle Cluster File System (ocfs)
> > # --------------------------------------------
> > #
> > diff -Nru a/lib/blkid/probe.c b/lib/blkid/probe.c
> > --- a/lib/blkid/probe.c	Wed Feb  4 00:21:03 2004
> > +++ b/lib/blkid/probe.c	Wed Feb  4 00:21:03 2004
> > @@ -312,6 +312,36 @@
> >  	return 1;
> >  }
> >  
> > +static int probe_ocfs(int fd __BLKID_ATTR((unused)), 
> > +		      blkid_cache cache __BLKID_ATTR((unused)), 
> > +		      blkid_dev dev,
> > +		      struct blkid_magic *id __BLKID_ATTR((unused)), 
> > +		      unsigned char *buf)
> > +{
> > +	struct ocfs_volume_header ovh;
> > +	struct ocfs_volume_label ovl;
> > +	
> > +	if (lseek(fd, 0, SEEK_SET) != 0)
> > +		return -1;
> > +
> > +	if (read(fd, (char *) &ovh, sizeof(ovh)) != sizeof(ovh))
> > +		return -1;
> > +
> > +	if (strncmp(ovh.signature, OCFS_MAGIC, sizeof(OCFS_MAGIC)) != 0)
> > +		return -1;
> > +
> > +	if (lseek(fd, 512, SEEK_SET) != 512)
> > +		return -1;
> > +
> > +	if (read(fd, (char *) &ovl, sizeof(ovl)) != sizeof(ovl)) 
> > +		return -1;
> > +
> > +	blkid_set_tag(dev, "LABEL", ovl.label, ocfslabellen(ovl));
> > +	blkid_set_tag(dev, "MOUNT", ovh.mount, ocfsmountlen(ovh));
> > +	set_uuid(dev, ovl.vol_id);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * BLKID_BLK_OFFS is at least as large as the highest bim_kboff defined
> >   * in the type_array table below + bim_kbalign.
> > @@ -371,6 +401,7 @@
> >    { "swap",	 0, 0x1ff6, 10, "SWAPSPACE2",		0 },
> >    { "swap",	 0, 0x3ff6, 10, "SWAP-SPACE",		0 },
> >    { "swap",	 0, 0x3ff6, 10, "SWAPSPACE2",		0 },
> > +  { "ocfs2",	 0,	 8,  9,	 "OracleCFS",  probe_ocfs },
> >    {   NULL,	 0,	 0,  0, NULL,			NULL }
> >  };
> >  
> > diff -Nru a/lib/blkid/probe.h b/lib/blkid/probe.h
> > --- a/lib/blkid/probe.h	Wed Feb  4 00:21:03 2004
> > +++ b/lib/blkid/probe.h	Wed Feb  4 00:21:03 2004
> > @@ -209,6 +209,27 @@
> >  	__u32	h_blksize;
> >  };
> >  
> > +struct ocfs_volume_header {
> > +	u_char	minor_version[4];
> > +	u_char	major_version[4];
> > +	u_char	signature[128];
> > +	u_char  mount[128];
> > +	u_char  mount_len[2];
> > +};
> > +
> > +struct ocfs_volume_label {
> > +	u_char	disk_lock[48];
> > +	u_char	label[64];	
> > +	u_char	label_len[2];
> > +	u_char  vol_id[16];
> > +	u_char  vol_id_len[2];
> > +};
> > +
> > +#define ocfslabellen(o)	((uint)o.label_len[0] + (((uint) o.label_len[1]) << 8))
> > +#define ocfsmountlen(o)	((uint)o.mount_len[0] + (((uint) o.mount_len[1])<<8))
> > +
> > +#define OCFS_MAGIC "OracleCFS"
> > +
> >  #define ISODCL(from, to) (to - from + 1)
> >  struct iso_volume_descriptor {
> >  	char type[ISODCL(1,1)]; /* 711 */
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel@oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
