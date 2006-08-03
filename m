From: tao.ma <tao.ma@oracle.com>
Date: Thu Aug  3 19:16:45 2006
Subject: [Ocfs2-devel] A patch for ocfs2 source configuration process.
In-Reply-To: <20060803222046.GA23246@ca-server1.us.oracle.com>
References: <44D1B373.7020107@oracle.com>
	<20060803222046.GA23246@ca-server1.us.oracle.com>
Message-ID: <44D2ADF8.9090704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have updated my Asianux2.0 to Asianux2.0sp1, kernel version is 2.6.9-34.
vendor.guess still get the wrong string "rhel4", but the configuration 
is right. It find my right kernel version.
So I think that is not a problem in this bew version of Asianux2.0sp1.
Joel Becker wrote:

>On Thu, Aug 03, 2006 at 04:27:31PM +0800, tao.ma wrote:
>  
>
>>    After do the configuration I find a strange thing. Although my
>>kernel is "2.6.9-11.19AX"(Asianux2.0 on a vmware server with a single
>>processor configured), the configuration find that it is
>>2.6.9-11.19AX-smp. So after I make and install, those *.ko went to the
>>wrong place.
>>    
>>
>
>	Interesting.
>
>  
>
>>The reason is:
>>1. When vendor/ax2/vendor.guess runs.
>>The script is :if [ "`rpm -qf /etc/asianux-release --qf '%{VERSION}'
>>2>/dev/null`" != "8AX" ]
>>while in my machine it is "2.0", not "8AX".
>>    
>>
>
>	Hmm, I wonder where we got 8AX (from someone with Aisianux, I'm
>sure, I'm going to check...).  Hm, the logs don't say where I got it
>from.  Can someone on this list verify what that should be?  Anyone with
>Asianux, please respond with the output of:
>
>    # rpm -qf /etc/asianux-release --qf '%{VERSION}'
>
>  
>
>>I also modify the script in vendor.guess. In asianux2.0, In /etc, you
>>can find
>>redhat-release and asianux-release.  So the vendor.guess will get the
>>wrong string
>>"ax2
>>rhel4".
>>    
>>
>
>  
>
>>Attachment is my patch. Hope it can help.
>>    
>>
>
>	NAK.  The entire point of ./vendor.guess is that it has
>absolutely ZERO vendor-specific knowledge.  We're not adding
>vendor-specific knowledge to the generic script.
>	That said, Asianux also keeping /etc/redhat-release is really
>broken.  Bad Asianux.  _That_ said, we have to deal with the real world.
>I suspect that the sort order solves it.  If we exit with our first
>successful vendor, we win (it will find asianux before redhat).
>
>Joel
>
>  
>



<http://www.oracle.com/cdc/>
