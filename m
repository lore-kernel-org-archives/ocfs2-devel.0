From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Date: Wed, 22 Dec 2010 08:12:43 -0000
Subject: [Ocfs2-devel] 2.6.36 OCFS unstable
In-Reply-To: <20101209021632.GI21913@mail.oracle.com>
References: <20101112190432.GB2364@nik-comp.lan>
	<20101209021632.GI21913@mail.oracle.com>
Message-ID: <20101222081230.GH3873@pcnci.linuxbox.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 08, 2010 at 06:16:33PM -0800, Joel Becker wrote:
> 	Sorry I didn't notice earlier, this email was stuck in the
> moderation queue.  I've added myself to this bug and forwarded the
> information to the owner of fs/dlm.
Hello Joel!
no problem, although I was forced to replace OCFS in the meantime due to
problems, so I'm no longer to help much debugging it :(

Do You have any news regarding DLM problems?


> 	These GPFs are weird!  We don't see anyone with these
> conditions.  Do you have very little memory?  Anything weird about your
> hardware?
> 	Also, are you up to bisecting the problem?  This involves
> building and testing multiple kernel versions.
The cluster nodes had at least 4GB of memory each..
I don't see a chance do bisect this, the crashes were quite rare, so
it would take months :(

> 
> Joel
> 
> -- 
> 
> "If you took all of the grains of sand in the world, and lined
>  them up end to end in a row, you'd be working for the government!"
> 	- Mr. Interesting
> 
> Joel Becker
> Senior Development Manager
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis at linuxbox.cz
-------------------------------------
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 198 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101222/f329b4cf/attachment-0001.bin 
