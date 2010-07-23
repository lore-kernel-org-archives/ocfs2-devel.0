From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Fri, 23 Jul 2010 10:43:17 -0700 (PDT)
Subject: [Ocfs2-devel] [PATCH V3 0/8] Cleancache: overview
In-Reply-To: <4C49AFAE.1070300@vflare.org>
References: <20100621231809.GA11111@ca-server1.us.oracle.com4C49468B.40307@vflare.org>
	<840b32ff-a303-468e-9d4e-30fc92f629f8@default>
	<20100723140440.GA12423@infradead.org>
	<364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default
	4C49AFAE.1070300@vflare.org>
Message-ID: <537098fb-f049-482a-97cf-b3695bf2c340@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ngupta@vflare.org
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org, Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk, adilger@Sun.COM, tytso@mit.edu, mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org, JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>, npiggin@suse.de, Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>

> From: Nitin Gupta [mailto:ngupta at vflare.org]
> Sent: Friday, July 23, 2010 9:05 AM
> To: Dan Magenheimer
> Cc: Christoph Hellwig; akpm at linux-foundation.org; Chris Mason;
> viro at zeniv.linux.org.uk; adilger at sun.com; tytso at mit.edu;
> mfasheh at suse.com; Joel Becker; matthew at wil.cx; linux-
> btrfs at vger.kernel.org; linux-kernel at vger.kernel.org; linux-
> fsdevel at vger.kernel.org; linux-ext4 at vger.kernel.org; ocfs2-
> devel at oss.oracle.com; linux-mm at kvack.org; jeremy at goop.org;
> JBeulich at novell.com; Kurt Hackel; npiggin at suse.de; Dave Mccracken;
> riel at redhat.com; avi at redhat.com; Konrad Wilk
> Subject: Re: [PATCH V3 0/8] Cleancache: overview
> 
> On 07/23/2010 08:14 PM, Dan Magenheimer wrote:
> >> From: Christoph Hellwig [mailto:hch at infradead.org]
> 
> 
> >> Also making the ops vector global is just a bad idea.
> >> There is nothing making this sort of caching inherently global.
> >
> > I'm not sure I understand your point, but two very different
> > users of cleancache have been provided, and more will be
> > discussed at the MM summit next month.
> >
> > Do you have a suggestion on how to avoid a global ops
> > vector while still serving the needs of both existing
> > users?
> 
> Maybe introduce cleancache_register(struct cleancache_ops *ops)?
> This will allow making cleancache_ops non-global. No value add
> but maybe that's cleaner?

Oh, OK, that seems reasonable.

Dan
