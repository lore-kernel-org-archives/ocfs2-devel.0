From: Gang He <GHe@suse.com>
Date: Thu, 26 Dec 2019 08:08:03 +0000
Subject: [Ocfs2-devel] Cannot compile ocfs2 kernel module directory
In-Reply-To: <CAK7LNAR+_8kgmNBDETJB-AXuLAtmiuPMLN_iKLfHKBVPqwV=Dw@mail.gmail.com>
References: <CH2PR18MB32065BA80B241E7B0B55429FCF290@CH2PR18MB3206.namprd18.prod.outlook.com>
	<2967264abe074c74be8e01f0a3fa04da@SOC-EX01V.e01.socionext.com>
	<CH2PR18MB3206BAD26F3F4C6BD962426ECF280@CH2PR18MB3206.namprd18.prod.outlook.com>
	<CAK7LNAR+_8kgmNBDETJB-AXuLAtmiuPMLN_iKLfHKBVPqwV=Dw@mail.gmail.com>
Message-ID: <CH2PR18MB3206ADAC7A913CA1B601E035CF2B0@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Yamada,

The patch looks Ok for me.
Now I can compile ocfs2 kernel module directory with the previous command line.

Thanks
Gang

> -----Original Message-----
> From: Masahiro Yamada [mailto:masahiroy at kernel.org]
> Sent: 2019?12?25? 23:51
> To: Gang He <GHe@suse.com>
> Cc: ocfs2-devel at oss.oracle.com
> Subject: Re: Cannot compile ocfs2 kernel module directory
> 
> Hi Gang,
> 
> On Wed, Dec 25, 2019 at 4:21 PM Gang He <GHe@suse.com> wrote:
> >
> > Hello Yamada,
> >
> > Thank for your reply,
> > I applied your patch, but still have some compile error.
> >
> 
> I missed to fix up fs/ocfs2/dlmfs/.
> 
> I attached a v2 patch.
> 
> 
> 
> 
> --
> Best Regards
> Masahiro Yamada
