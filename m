From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 04 Jan 2011 14:33:20 -0800
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
 mlog(0).
In-Reply-To: <20110104221517.GB30671@mail.oracle.com>
References: <4D12F7E7.1090204@tao.ma>
	<20101231125217.GC21179@mail.oracle.com>	<4D1DF2A3.9090106@tao.ma>
	<20101231223951.GC20521@mail.oracle.com>	<4D22E32D.40406@tao.ma>
	<20110104221517.GB30671@mail.oracle.com>
Message-ID: <4D23A030.6000306@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/04/2011 02:15 PM, Joel Becker wrote:
>
> 	I think what matters to count is dirs, because files disappear
> when you're not using them.
> 	If you have 319 trace event directories, that's 319 inodes.  On
> my x86, a vanilla struct inode is 360 bytes and a dentry is 136 bytes.
> That's 154K always in RAM for these knobs.  I gotta say that I'm not too
> worried about 154K.  On x86_64 (ca-build24) this grows to 241K.  I
> imagine it will double when cluster and dlm are moved to similar trace
> events.
> 	Are we OK with 300K on x86 and 500K on x86_64 always used up by
> these tracing entries?

I'm ok with that.
