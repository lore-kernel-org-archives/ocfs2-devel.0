From: Martin.Francis at ferguson.com <Martin.Francis@ferguson.com>
Date: Wed, 23 Dec 2009 11:18:47 -0500
Subject: [Ocfs2-devel] OCFS2 support over veritas disks
Message-ID: <3079FCE0CBCA164983F73328423F7ADFDCE4AF@WOSNPNTCMX018.DS.WOLSELEY.COM>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi

I  have a support question on OCFS2 over multipath  disks

I am setting up OCFS2 disks on RHEL5. (2.6.18-128.1.10.el5)

 

OCFS2 doc refers to using native disk names like /dev/sda, but doesnt
seem to describe how to use multipathed devices as in linux native
dm-multipath or veritas dmp

So I decided to experiment with veritas dmp devices,

 

I created an OCFS2 over veritas multipathed device sdf ( which is dmp
node with two underlying paths sdf and sdl )

 

 

mkfs.ocfs2 -b 4K -C 32K -L ocr_vote /dev/vx/rdmp/sdf

 

The filesystem seems to work just fine.I disabled the individual paths
to the LUNS using veritas DMP commands and OCFS2 did not encounter any
issues.

 

But OCFS2 doesn't seem to take the DMP metanode, instead it uses
individual paths as in output below ( sdf and sdl ).

So I don't know if the load balancing and other dmp features are
effective.  Is this the usual behavior of OCFS2 handling multipath
devices ?

 

mounted.ocfs2 -f

Device                FS     Nodes

/dev/sdf              ocfs2  a00062, a00060

/dev/sdl              ocfs2  a00062, a00060

 

Is there any official support statement on what multipath vendors are
supported and recommended configurations for multipathing

 

 

________________________________________________

Martin Francis

Systems Engineering/Infrastructure Services - Engineering

Wolseley 12500 Jefferson Avenue.Newport News,VA 23602

Phone:757-969-2816 Cell:602-315-7648

www.wolseley.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20091223/7425f790/attachment-0001.html 
