From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Wed Aug 25 10:48:46 2004
Subject: [Ocfs2-devel] some performance data.
In-Reply-To: <3ACA40606221794F80A5670F0AF15F84054B267B@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F84054B267B@pdsmsx403>
Message-ID: <20040825154840.GC14518@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

also, I assume that is nondirect io read/write
can you modify fileben to do O_DIRECT only and see how that one compares
?


On Wed, Aug 25, 2004 at 11:39:21AM +0800, Ling, Xiaofeng wrote:
> I've tried redhat GFS and get some performance data.
> Both are with two nodes mount. ocfs2 svn 1383.kernel 2.6.6
> seems the current read performance in ocfs2 is a little low.
> 
> write 128K file
> =============================
> GFS
>  ./fileben -0 -p 10 -a -f /gfs/aaa
> total:128.000K Time:0.448 Rate:285714KB
> total:128.000K Time:0.337 Rate:379822KB
> total:128.000K Time:0.335 Rate:382090KB
> total:128.000K Time:0.299 Rate:428094KB
> total:128.000K Time:0.293 Rate:436860KB
> total:128.000K Time:0.308 Rate:415584KB
> total:128.000K Time:0.285 Rate:449123KB
> total:128.000K Time:0.300 Rate:426667KB
> total:128.000K Time:0.313 Rate:408946KB
> total:128.000K Time:0.290 Rate:441379KB
> total:1280.000K Time:3.615 Rate:354080KB
> OCFS2
>  ./fileben -0 -p 10 -a -f /ocfs/aaa
> total:128.000K Time:0.371 Rate:345013KB
> total:128.000K Time:0.349 Rate:366762KB
> total:128.000K Time:0.301 Rate:425249KB
> total:128.000K Time:0.315 Rate:406349KB
> total:128.000K Time:0.286 Rate:447552KB
> total:128.000K Time:0.278 Rate:460432KB
> total:128.000K Time:0.376 Rate:340426KB
> total:128.000K Time:0.314 Rate:407643KB
> total:128.000K Time:0.268 Rate:477612KB
> total:128.000K Time:0.278 Rate:460432KB
> total:1280.000K Time:3.554 Rate:360158KB
> EXT3
> ./fileben -0 -p 10 -a -f /mnt/aaa
> create file /mnt/aaa of size 128K successfully
> total:128.000K Time:0.141 Rate:907801KB
> total:128.000K Time:0.100 Rate:1280000KB
> total:128.000K Time:0.094 Rate:1361702KB
> total:128.000K Time:0.087 Rate:1471264KB
> total:128.000K Time:0.086 Rate:1488372KB
> total:128.000K Time:0.096 Rate:1333333KB
> total:128.000K Time:0.086 Rate:1488372KB
> total:128.000K Time:0.096 Rate:1333333KB
> total:128.000K Time:0.084 Rate:1523810KB
> total:128.000K Time:0.081 Rate:1580247KB
> total:1280.000K Time:1.284 Rate:996885KB
> 
> read 128K file
> =========================================
> GFS
>  ./fileben -1 -p 10 -a -f /gfs/aaa
> total:128.000K Time:0.156 Rate:820513KB
> total:128.000K Time:0.084 Rate:1523810KB
> total:128.000K Time:0.076 Rate:1684211KB
> total:128.000K Time:0.076 Rate:1684211KB
> total:128.000K Time:0.075 Rate:1706667KB
> total:128.000K Time:0.075 Rate:1706667KB
> total:128.000K Time:0.075 Rate:1706667KB
> total:128.000K Time:0.082 Rate:1560976KB
> total:128.000K Time:0.076 Rate:1684211KB
> total:128.000K Time:0.076 Rate:1684211KB
> total:1280.000K Time:1.270 Rate:1007874KB
> OCFS2
>  ./fileben -1 -p 10 -a -f /ocfs/aaa
> total:128.000K Time:0.303 Rate:422442KB
> total:128.000K Time:0.272 Rate:470588KB
> total:128.000K Time:0.238 Rate:537815KB
> total:128.000K Time:0.235 Rate:544681KB
> total:128.000K Time:0.249 Rate:514056KB
> total:128.000K Time:0.284 Rate:450704KB
> total:128.000K Time:0.308 Rate:415584KB
> total:128.000K Time:0.252 Rate:507937KB
> total:128.000K Time:0.227 Rate:563877KB
> total:128.000K Time:0.228 Rate:561404KB
> total:1280.000K Time:3.025 Rate:423140KB
> EXT3
>  ./fileben -1 -p 10 -a -f /mnt/aaa
> total:128.000K Time:0.142 Rate:901408KB
> total:128.000K Time:0.051 Rate:2509804KB
> total:128.000K Time:0.047 Rate:2723404KB
> total:128.000K Time:0.047 Rate:2723404KB
> total:128.000K Time:0.046 Rate:2782609KB
> total:128.000K Time:0.046 Rate:2782609KB
> total:128.000K Time:0.046 Rate:2782609KB
> total:128.000K Time:0.064 Rate:2000000KB
> total:128.000K Time:0.046 Rate:2782609KB
> total:128.000K Time:0.046 Rate:2782609KB
> total:1280.000K Time:0.953 Rate:1343127KB
> 
> directory operation
> mkdir,rmdir,mkdir,mvdir
> =============================
> [root@xling benchmark]# ./db /gfs
> total:100, rate:2410.7 dir/sec
> total:100, rate:31786.4 dir/sec
> total:100, rate:1313.7 dir/sec
> total:100, rate:1262.6 dir/sec
> [root@xling benchmark]./db /ocfs
> total:100, rate:20128.8 dir/sec
> total:100, rate:46019.3 dir/sec
> total:100, rate:20601.6 dir/sec
> total:100, rate:18155.4 dir/sec
> [root@xling benchmark]# ./db /mnt
> total:100, rate:2923.8 dir/sec
> total:100, rate:84317.0 dir/sec
> total:100, rate:34423.4 dir/sec
> total:100, rate:47687.2 dir/sec
> 
> another try
> =============================
> [root@xling benchmark]# ./db /gfs
> total:100, rate:5466.0 dir/sec
> total:100, rate:32030.7 dir/sec
> total:100, rate:2253.5 dir/sec
> total:100, rate:10586.5 dir/sec
> [root@xling benchmark]# ./db /ocfs
> total:100, rate:18109.4 dir/sec
> total:100, rate:46061.7 dir/sec
> total:100, rate:22050.7 dir/sec
> total:100, rate:18501.4 dir/sec
> [root@xling benchmark]# ./db /mnt
> total:100, rate:36710.7 dir/sec
> total:100, rate:71633.2 dir/sec
> total:100, rate:30816.6 dir/sec
> total:100, rate:42826.6 dir/sec
> 
> -------------------
> Ling Xiaofeng(Daniel)
> Intel China Software Lab.
> iNet: 8-752-1243
> 8621-52574545-1243(O)
> xfling@users.sourceforge.net
> Opinions are my own and don't represent those of my employer 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
