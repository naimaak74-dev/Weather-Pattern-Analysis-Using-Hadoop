import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.mapreduce.Mapper;

public class WeatherMapper
        extends Mapper<LongWritable, Text, Text, DoubleWritable> {

    private Text stationKey = new Text();
    private DoubleWritable temperatureValue = new DoubleWritable();

    @Override
    protected void map(
            LongWritable key,
            Text value,
            Context context)
            throws IOException, InterruptedException {

        String line = value.toString();

        // Empty line skip
        if (line.trim().isEmpty()) {
            return;
        }

        String[] fields = line.split(",", -1);

        // NOAA record needs at least 4 fields
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

            // NOAA temperature is in tenths of degree Celsius
            double temperature = rawValue / 10.0;

            stationKey.set(station);
            temperatureValue.set(temperature);

            context.write(stationKey, temperatureValue);

        } catch (NumberFormatException e) {
            // Invalid numeric value skip
        }
    }
}