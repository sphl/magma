---
title: Sample Report
---

{% capture template %}

<div class="targets">
    <p>
        Welcome to the magma report. In here you will be able to see the results of the benched fuzzers
        over the target libraries.
        See <a href="https://github.com/HexHive/magma/blob/master/README.md">here</a> for build and run details.
    </p>

    <h2>Benchmark process</h2>
       <p>
           The differents fuzzers are run over the target libraries in which multiple patches have been implemented.
           These patches reintroduce previous corrected bugs. Once the fuzzer campaign is done you will find in this report how much
           bugs where triggered and at what moment. All this gives us enought material to establish a benchmark for the used fuzzers.
        </p>
</div>

<div class="target_description">
    <h2>Targeted Libraries</h2>
    <p>Here are all the currently supported libraries in magma.</p>
    <ul id="target_list">
        
        <li><a href= "libraries/poppler.html">poppler</a> has a total of 22 implemented bugs</li>
        
        <li><a href= "libraries/libpng.html">libpng</a> has a total of 7 implemented bugs</li>
        
        <li><a href= "libraries/libtiff.html">libtiff</a> has a total of 14 implemented bugs</li>
        
        <li><a href= "libraries/libxml2.html">libxml2</a> has a total of 18 implemented bugs</li>
        
        <li><a href= "libraries/sqlite3.html">sqlite3</a> has a total of 20 implemented bugs</li>
        
        <li><a href= "libraries/php.html">php</a> has a total of 16 implemented bugs</li>
        
        <li><a href= "libraries/openssl.html">openssl</a> has a total of 21 implemented bugs</li>
        
    </ul>
    <p>
        Total number of patches is 118
    </p>
</div>

<div class="fuzzers">
    <h2>Evaluated Fuzzers</h2>
    <p>Currently magma can evaluate 6</p>
    <ul id="fuzzer_list">
        
        <li><a href= "fuzzers/moptafl.html">moptafl</a></li>
        
        <li><a href= "fuzzers/aflfast.html">aflfast</a></li>
        
        <li><a href= "fuzzers/aflplusplus.html">aflplusplus</a></li>
        
        <li><a href= "fuzzers/honggfuzz.html">honggfuzz</a></li>
        
        <li><a href= "fuzzers/fairfuzz.html">fairfuzz</a></li>
        
        <li><a href= "fuzzers/afl.html">afl</a></li>
        
    </ul>
</div>

<div class="general graph">
    <h2>General result</h2>
    <div>
        <img src ="./plots/mean_variance_bar.svg">
    </div>
    <div>
        <img src ="./plots/signplot.svg">
    </div>
    <div>
        <img src ="./plots/expected_time_to_bug_heat.svg">
    </div>
</div>

{% endcapture %}
{{ template | replace: '    ', ''}}