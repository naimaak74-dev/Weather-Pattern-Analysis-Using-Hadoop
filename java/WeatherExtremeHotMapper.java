import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapreduce.Mapper;

public class WeatherExtremeHotMapper
        extends Mapper<LongWritable, Text, Text, IntWritable> {

    private Text stationKey = new Text();
    private IntWritable one = new IntWritable(1);

    @Override
    protected void map(
            LongWritable key,
            Text value,
            Context context)
            throws IOException, InterruptedException {

        String line = value.toString();

        if (line.trim().isEmpty()) {
            return;
        }

        String[] fields = line.split(",", -1);

        if (fields.length < 4) {
            return;
        }

        String station = fields[0].trim();
        String element = fields[2].trim();
        String valueString = fields[3].trim();

        // Only TMAX records
        if (!element.equals("TMAX")) {
            return;
        }

        try {

            int rawValue = Integer.parseInt(valueString);

            // Missing value
            if (rawValue == -9999) {
                return;
            }

            // TMAX >= 35°C
            // NOAA stores TMAX in tenths of °C
            if (rawValue >= 350) {

                stationKey.set(station);

                context.write(
                    stationKey,
                    one
                );
            }

        } catch (NumberFormatException e) {
            // Invalid value skipped
        }
    }
}