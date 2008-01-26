From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Sat Jan 26 22:34:31 2008
Subject: [Ocfs2-devel] /etc/mkfs.ocfs2.conf support
In-Reply-To: <20080125185146.GU23506@ca-server1.us.oracle.com>
References: <20080123094730.GA18317@baloo.nue.novell.com>
	<20080125185146.GU23506@ca-server1.us.oracle.com>
Message-ID: <20080127063421.GB8213@baloo.nue.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 25, 2008 at 10:51:46AM -0800, Mark Fasheh wrote:
> On Wed, Jan 23, 2008 at 03:17:30PM +0530, Goldwyn Rodrigues wrote:
> > 
> > +
> > +static const char *config_fn[] = { "/etc/mkfs.ocfs2.conf", 0 };
> > +static const char *default_files[] = { "<default>", 0 };
> > +const char *mkfs_default_profile = 
> > +  "[defaults]\n"
> > +  "	block-size = 4096\n"
> > +  "\n"
> > +  "[fs_types]\n"
> > +  "	datafiles = {\n"
> > +  "		journal = {\n"
> > +  "			size = 8192\n"
> > +  "		}\n"
> > +  "	}\n"
> 
> Is this making '-T datafiles' the default? It should not be...
> 	--Mark
> 

No, it does not. It means that whenever the user supplies '-T datafiles'
in the command line, the journal size would be set to 8192 by default.
This was the only default value I could interpret from the current code.

However, it does assume the default block size is 4K. I will remove
that.


-- 
Goldwyn
